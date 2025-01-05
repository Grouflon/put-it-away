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

var current_items: Array[Item]
var active_rules: Array[RuleScript]

var day_result: DayResult

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
			spawn_and_engage_next_item()
			pass
			
		GameState.COMMENTS:
			game_scene.comments_panel.begin_comment_fill()
			
			var comments_pool: Array[GDScript]
			comments_pool.append_array(game_data.global_comments)
			comments_pool.append_array(game_data.days[current_day].comments)
			
			for comment in comments_pool:
				if comment == null: continue
				
				var n = Node.new()
				n.set_script(comment)
				var comment_script: = n as CommentScript
				if comment == null:
					push_error("%s is not of type CommentScript" % comment)
					continue
				
				if !comment_script.is_valid(day_result): continue

				var avatar = comment_script.get_avatar()
				var author = comment_script.get_author()
				var body = comment_script.get_body()
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
	var results = tools.point_cast_z_ordered(input.mouse_position, 1)
	for result in results:
		if result.get_parent() == null: continue
		input.hovered_objects.append(result.get_parent())
	if input.hovered_objects.size() > 0:
		input.topmost_hovered_object = input.hovered_objects[0]
		
	#print(input.topmost_hovered_object)
	
	# Process state machine
	match game_state:
		GameState.DAY_INTRO:
			pass
		
		GameState.GAME:
			if input.topmost_hovered_object is BookBox && input.interact_just_pressed:
				if game_scene.book_box.has_item_engaged():
					game_scene.book_box.project_engaged_item()
					spawn_and_engage_next_item()
				else:
					# do some fix
					pass					
			
			item_manager.process(input)
			
			var any_book_out = false
			for item in current_items:
				if item is Book:
					any_book_out = true
					break
			
			if !any_book_out && !game_scene.book_box.has_item_engaged() && item_pool.size() == 0:
				check_rules()
				set_state(GameState.COMMENTS)
			pass
			
		GameState.END:
			pass

func on_item_dropped(item: Item):
	var should_remove: = false
	
	if input.hovered_objects.has(game_scene.keep_zone):
		day_result.today_stored_items.append(item)
		day_result.total_stored_items.append(item)
		should_remove = true
		
	elif input.hovered_objects.has(game_scene.ditch_zone):
		day_result.today_discarded_items.append(item)
		day_result.total_discarded_items.append(item)	
		should_remove = true
	
	if should_remove:
		item.get_parent().remove_child(item)
		tools.remove_from_array(current_items, item)
		
func on_comment_panel_closed():
	if (current_day + 1) < game_data.days.size():
		setup_day(current_day+1)
		set_state(GameState.DAY_INTRO)
	else:
		set_state(GameState.END)
		pass
	
func check_rules():
	for rule in game_data.days[current_day].rules:
		if rule == null: continue
		
		var n = Node.new()
		n.set_script(rule)
		var rule_script: = n as RuleScript
		if rule_script != null && !rule_script.check_rule(day_result):
			day_result.today_broken_rules += 1
			continue
		day_result.today_followed_rules += 1
		
func reset_game():
	for item in current_items:
		item.queue_free()
	for item in day_result.total_stored_items:
		item.queue_free()
	for item in day_result.total_discarded_items:
		item.queue_free()
	for rule in active_rules:
		rule.queue_free()
		
	active_rules.clear()
	current_items.clear()
	item_pool.clear()
	
	game_scene.book_box.reset()
	day_result = null

func setup_day(day_index: int):
	assert(game_data.days.size() > day_index)
	
	# clear previous day
	var persistent_items: Array[Item]
	item_pool.clear()
	for item in current_items:
		if item.persist_between_days:
			persistent_items.append(item)
			continue
		item.queue_free()
	current_items.clear()
	current_items.append_array(persistent_items)
	
	for rule in active_rules:
		rule.queue_free()
	active_rules.clear()
	
	# setup new day
	current_day = day_index
	var new_day_result = DayResult.new()
	if day_result != null:
		new_day_result.total_stored_items.append_array(day_result.total_stored_items)
		new_day_result.total_discarded_items.append_array(day_result.total_discarded_items)
	day_result = new_day_result
	
	# item box
	for item in game_data.days[current_day].box_content:
		if item == null: continue
		item_pool.append(item)
	
	# rules
	var rules_pool: Array[GDScript]
	rules_pool.append_array(game_data.global_rules)
	rules_pool.append_array(game_data.days[current_day].rules)
	for rule in rules_pool:
		if rule == null: continue
		
		var n = Node.new()
		n.set_script(rule)
		var rule_script: = n as RuleScript
		if rule_script == null:
			push_error("%s is not of type RuleScript" % rule)
			continue

		var rule_item: Rule = game_data.rule_prefab.instantiate()
		rule_item.set_text(rule_script.get_text())
		game_scene.add_child(rule_item)
		rule_item.position = Vector2(200, 20) + active_rules.size() * Vector2(215, 0)
		
		current_items.append(rule_item)
		active_rules.append(rule_script)
	
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
	
func spawn_and_engage_next_item():
	assert(!game_scene.book_box.has_item_engaged())
	
	if item_pool.size() <= 0:
		return
	
	var item = item_pool[0].instantiate()
	assert(item is Item)
	
	item_pool.remove_at(0)
	game_scene.add_child(item)
	game_scene.book_box.engage_item(item)
	#item.position = Vector2(250, 220) + current_items.size() * Vector2(30, 30)
	#game_scene.book_box.update_item_count(item_pool.size())
	
	current_items.append(item)
	
