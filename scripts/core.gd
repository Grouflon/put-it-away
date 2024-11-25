extends Node
class_name GameCore

# immutable stuff
@export var game_data: GameData
@export var item_manager: ItemManager
var game_scene: GameScene
var day_format_string: String

enum GameState
{
	NONE,
	DAY_INTRO,
	GAME,
	END,
}
var game_state: GameState = GameState.NONE
var current_day: int 
var item_pool: Array[PackedScene]
var spawned_items: Array[Item]
var spawned_books: Array[Book]
var input: InputData

func _ready() -> void:
	game_scene = $"/root/GameScene"
	assert(game_scene != null)
	day_format_string = game_scene.day_text.text
	
	item_manager.item_dropped.connect(on_item_dropped)
	item_manager.initialize()
	
	setup_day(0)
	set_state(GameState.DAY_INTRO)
	
func set_state(state: GameState):
	# exit state
	match game_state:
		GameState.DAY_INTRO:
			pass
		
		GameState.GAME:
			pass
	
	game_state = state
	
	# enter state
	match game_state:
		GameState.DAY_INTRO:
			game_scene.animation_player.animation_finished.connect(day_intro_animation_finished)
			game_scene.animation_player.play("day_intro")
		
		GameState.GAME:
			pass
			
		GameState.END:
			game_scene.animation_player.animation_finished.connect(end_animation_finished)
			game_scene.animation_player.play("end")
			pass
			

func _process(_delta: float):
	# Input
	input = InputData.new()
	input.interact_just_pressed = Input.is_action_just_pressed("Interact")
	input.interact_just_released = Input.is_action_just_released("Interact")
	input.interact_down = Input.is_action_pressed("Interact")
	input.mouse_position = get_viewport().get_mouse_position()
	var results = game_scene.point_cast_z_ordered(input.mouse_position)
	for result in results:
		if result.get_parent() == null: continue
		input.hovered_objects.append(result.get_parent())
	if input.hovered_objects.size() > 0:
		input.topmost_hovered_object = input.hovered_objects[0]
		
	#print(input.hovered_object)
	
	# Process managers
	
	# Process state machine
	match game_state:
		GameState.DAY_INTRO:
			pass
		
		GameState.GAME:
			if input.topmost_hovered_object is BookBox && input.interact_just_pressed:
				if item_pool.size() > 0:
					var item = item_pool[0].instantiate()
					item_pool.remove_at(0)
					game_scene.add_child(item)
					item.position = Vector2(250, 220) + spawned_items.size() * Vector2(30, 30)
					game_scene.book_box.update_item_count(item_pool.size())
					
					if item is Item:
						spawned_items.append(item)
						
					if item is Book:
						spawned_books.append(item)
					
			
			item_manager.process(input)
			
			if spawned_books.size() == 0 && item_pool.size() == 0:
				if (current_day + 1) < game_data.days.size():
					setup_day(current_day+1)
					set_state(GameState.DAY_INTRO)
				else:
					set_state(GameState.END)
					pass
			pass
			
		GameState.END:
			pass

func on_item_dropped(item: Item):
	if input.hovered_objects.has(game_scene.keep_zone):
		tools.remove_from_array(spawned_items, item)
		tools.remove_from_array(spawned_books, item)
		item.queue_free()
		pass
	elif input.hovered_objects.has(game_scene.ditch_zone):
		tools.remove_from_array(spawned_items, item)
		tools.remove_from_array(spawned_books, item)
		item.queue_free()
		pass

func setup_day(day_index: int):
	assert(game_data.days.size() > day_index)
	
	# clear previous day
	item_pool.clear()
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()
	
	# setup new day
	current_day = day_index
	for item_data in game_data.days[current_day].box_content:
		item_pool.append(item_data)
	game_scene.book_box.update_item_count(item_pool.size())
	
	game_scene.day_text.text = day_format_string.format({"day": current_day + 1})
	

func day_intro_animation_finished(anim_name: StringName):
	assert(anim_name == "day_intro")
	game_scene.animation_player.animation_finished.disconnect(day_intro_animation_finished)
	set_state(GameState.GAME)
	
func end_animation_finished(anim_name: StringName):
	assert(anim_name == "end")
	game_scene.animation_player.animation_finished.disconnect(end_animation_finished)
	setup_day(0)
	set_state(GameState.DAY_INTRO)
