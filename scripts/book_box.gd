extends Node
class_name BookBox

@export var text: RichTextLabel

@export var spawn_point: Node2D
@export var wait_point: Node2D
@export var engagement_duration: float = 0.5
@export_range (0, 90) var engagement_max_angle: float

@export var projection_speed: float = 400
@export var projection_duration: float = 0.5
@export_range (0, 45) var projection_max_angle: float
@export_range (10, 2000) var projection_min_distance: float
@export_range (10, 2000) var projection_max_distance: float

var engaged_item: Item
var rng = RandomNumberGenerator.new()

var text_format_string: String
var initialized: bool # hack to work around shitty ready order thing
func initialize():
	if initialized: return
	text_format_string = text.text
	initialized = true
	
func reset():
	engaged_item = null

func update_item_count(item_count: int):
	initialize()
	text.text = text_format_string.format({"item_count": item_count})

func engage_item(item: Item):
	assert(item != null)
	
	if item.tween != null:
		item.tween.kill()
	
	item.position = spawn_point.global_position
	
	var engagement_angle: = rng.randf_range(-engagement_max_angle, engagement_max_angle)
	item.tween = get_tree().create_tween().set_parallel(true)
	item.tween.tween_property(item, "position", wait_point.global_position, engagement_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	item.tween.tween_property(item, "rotation_degrees", engagement_angle, engagement_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	item.can_be_dragged = false
	engaged_item = item

func has_item_engaged() -> bool:
	return engaged_item != null

func project_engaged_item():
	assert(has_item_engaged())
	
	if engaged_item.tween != null:
		engaged_item.tween.kill()
		
	var projection_distance: = rng.randf_range(projection_min_distance, projection_max_distance)
	#var projection_duration: = projection_distance / projection_speed
	var projection_angle: = rng.randf_range(-projection_max_angle, projection_max_angle)
		
	engaged_item.tween = get_tree().create_tween()
	engaged_item.tween.tween_property(engaged_item, "position", wait_point.global_position + Vector2(projection_distance, 0).rotated(deg_to_rad(projection_angle)), projection_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	engaged_item.can_be_dragged = true
	engaged_item = null
	
