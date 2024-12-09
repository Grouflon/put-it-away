extends Control
class_name CommentsPanel

@export_group("prefabs")
@export var comment_prefab: PackedScene

@export_group("layout")
@export var comments_container: Control
@export var no_comment_label: Control

signal panel_closed

func begin_comment_fill():
	for child in comments_container.get_children():
		comments_container.remove_child(child)
		
	comments_container.visible = false
	no_comment_label.visible = false
	
func end_comment_fill():
	if comments_container.get_children().size() > 0:
		comments_container.visible = true
	else:
		no_comment_label.visible = true

func add_comment(avatar: Texture2D, author: String, comment: String):
	var widget: = comment_prefab.instantiate() as CommentWidget
	
	widget.set_avatar(avatar)
	widget.set_author(author)
	widget.set_comment(comment)
	
	comments_container.add_child(widget)

func _on_button_pressed() -> void:
	panel_closed.emit()
