extends Control
class_name CommentWidget

@export var avatar: TextureRect
@export var author_label: Label
@export var comment_label: Label

const placeholder_avatar: Texture2D = preload("res://icon.svg")

func set_avatar(texture: Texture2D):
	if texture == null:
		avatar.texture = placeholder_avatar
	else:
		avatar.texture = texture
	
func set_author(author: String):
	author_label.text = author

func set_comment(comment: String):
	comment_label.text = comment
