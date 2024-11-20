extends Node2D
class_name Item

func _enter_tree() -> void:
	core.item_manager.register_item(self)

func _exit_tree() -> void:
	core.item_manager.unregister_item(self)
