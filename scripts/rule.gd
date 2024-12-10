extends Item
class_name Rule

@export var colors: Array[Color]

@export_group("layout")
@export var text_label: Label
@export var background: ColorRect


func _ready() -> void:
	if colors.size() > 0:
		var c = colors[randi_range(0, colors.size() - 1)]
		background.color = c

func set_text(text: String):
	text_label.text = text
