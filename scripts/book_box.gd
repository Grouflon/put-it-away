extends Node
class_name BookBox

@export var collider: Area2D
@export var text: RichTextLabel

func _ready():
	collider.mouse_entered.connect(mouse_entered)
	collider.mouse_exited.connect(mouse_exited)

func mouse_entered():
	pass
	
func mouse_exited():
	pass
