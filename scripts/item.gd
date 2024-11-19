extends Node2D
class_name Item

@export var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.mouse_entered.connect(on_mouse_entered)
	area.mouse_exited.connect(on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_mouse_entered():
	core.item_manager.notify_mouse_entered_item(self)
	pass
	
func on_mouse_exited():
	core.item_manager.notify_mouse_exited_item(self)
	pass
