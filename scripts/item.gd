extends Node2D
class_name Item

@export var persist_between_days: bool
var tween: Tween
var can_be_dragged: bool = true

func _enter_tree() -> void:
	core.item_manager.register_item(self)

func _exit_tree() -> void:
	core.item_manager.unregister_item(self)
