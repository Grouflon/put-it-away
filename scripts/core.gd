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
	COMMENTS,
	END,
}
var game_state: GameState = GameState.NONE
var current_day: int 
var item_pool: Array[PackedScene]
var spawned_items: Array[Item]
var spawned_books: Array[Book]
var spawned_rules: Array[Rule]

var today_kept_items: Array[Item]
var today_thrown_items: Array[Item]
var kept_items: Array[Item]
var thrown_items: Array[Item]
var today_followed_rules: Array[RuleData]
var today_broken_rules: Array[RuleData]

var input: InputData

func _ready() -> void:
	game_scene = $"/root/GameScene"
	assert(game_scene != null)
	day_format_string = game_scene.day_text.text
	
	game_scene.comments_panel.visible = false
	
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
			
		GameState.COMMENTS:
			game_scene.comments_panel.panel_closed.disconnect(on_comment_panel_closed)
			game_scene.comments_panel.visible = false
			pass
	
	game_state = state
	
	# enter state
	match game_state:
		GameState.DAY_INTRO:
			game_scene.animation_player.animation_finished.connect(day_intro_animation_finished)
			game_scene.animation_player.play("day_intro")
		
		GameState.GAME:
			pass
			
		GameState.COMMENTS:
			game_scene.comments_panel.begin_comment_fill()
			
			var comments_pool: Array[CommentData]
			comments_pool.append_array(game_data.global_comments)
			comments_pool.append_array(game_data.days[current_day].comments)
			
			for comment_data in comments_pool:
				if comment_data == null: continue
				
				var n = Node.new()
				n.set_script(comment_data.comment_script)
				var comment_script: = n as CommentScript
				if !comment_data.is_valid(comment_script): continue

				var avatar = comment_data.get_avatar(comment_script)
				var author = comment_data.get_author(comment_script)
				var body = comment_data.get_body(comment_script)
				game_scene.comments_panel.add_comment(avatar, author, body)
		
				n.queue_free()
			
			game_scene.comments_panel.end_comment_fill()
			
			game_scene.comments_panel.visible = true
			game_scene.comments_panel.panel_closed.connect(on_comment_panel_closed)
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
				check_rules()
				set_state(GameState.COMMENTS)
			pass
			
		GameState.END:
			pass

func on_item_dropped(item: Item):
	if input.hovered_objects.has(game_scene.keep_zone):
		tools.remove_from_array(spawned_items, item)
		if item is Book:
			tools.remove_from_array(spawned_books, item)
		if item is Rule:
			tools.remove_from_array(spawned_rules, item)
			
		today_kept_items.append(item)
		kept_items.append(item)
		item.get_parent().remove_child(item)
		pass
	elif input.hovered_objects.has(game_scene.ditch_zone):
		tools.remove_from_array(spawned_items, item)
		if item is Book:
			tools.remove_from_array(spawned_books, item)
		if item is Rule:
			tools.remove_from_array(spawned_rules, item)
		
		today_thrown_items.append(item)
		thrown_items.append(item)	
		item.get_parent().remove_child(item)
		pass
		
func on_comment_panel_closed():
	if (current_day + 1) < game_data.days.size():
		setup_day(current_day+1)
		set_state(GameState.DAY_INTRO)
	else:
		set_state(GameState.END)
		pass
	
func check_rules():
	for rule_data in game_data.days[current_day].rules:
		if rule_data == null: continue
		if rule_data.rule_script != null:
			var n = Node.new()
			n.set_script(rule_data.rule_script)
			var rule_script: = n as RuleScript
			if rule_script != null && !rule_script.check_rule():
				today_broken_rules.append(rule_data)
				continue
		today_followed_rules.append(rule_data)
		
func reset_game():
	item_pool.clear()
	for item in spawned_items:
		item.queue_free()
	for rule in spawned_rules:
		rule.queue_free()
	for item in kept_items:
		item.queue_free()
	for item in thrown_items:
		item.queue_free()
		
	spawned_items.clear()
	spawned_books.clear()
	spawned_rules.clear()
	kept_items.clear()
	thrown_items.clear()
	today_followed_rules.clear()
	today_broken_rules.clear()

func setup_day(day_index: int):
	assert(game_data.days.size() > day_index)
	
	# clear previous day
	var persistent_items: Array[Item]
	item_pool.clear()
	for item in spawned_items:
		if item.persist_between_days:
			persistent_items.append(item)
			continue
		item.queue_free()
	for rule in spawned_rules:
		rule.queue_free()
	spawned_items.clear()
	spawned_books.clear()
	spawned_rules.clear()
	today_kept_items.clear()
	today_thrown_items.clear()
	spawned_items.append_array(persistent_items)
	today_followed_rules.clear()
	today_broken_rules.clear()
	
	# setup new day
	current_day = day_index
	
	# item box
	for item in game_data.days[current_day].box_content:
		if item == null: continue
		item_pool.append(item)
	
	# rules
	for rule_data in game_data.days[current_day].rules:
		if rule_data == null: continue
		var rule: Rule = game_data.rule_prefab.instantiate()
		rule.set_data(rule_data)
		game_scene.add_child(rule)
		rule.position = Vector2(120, 20) + spawned_rules.size() * Vector2(215, 0)
		spawned_rules.append(rule)
	
	# UI
	game_scene.book_box.update_item_count(item_pool.size())
	game_scene.day_text.text = day_format_string.format({"day": current_day + 1})
	

func day_intro_animation_finished(anim_name: StringName):
	assert(anim_name == "day_intro")
	game_scene.animation_player.animation_finished.disconnect(day_intro_animation_finished)
	set_state(GameState.GAME)
	
func end_animation_finished(anim_name: StringName):
	assert(anim_name == "end")
	game_scene.animation_player.animation_finished.disconnect(end_animation_finished)
	reset_game()
	setup_day(0)
	set_state(GameState.DAY_INTRO)
