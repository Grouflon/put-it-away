extends Item
class_name Rule

@export var colors: Array[Color]

@export_group("layout")
@export var text: Label
@export var background: ColorRect


func _ready() -> void:
	if colors.size() > 0:
		var c = colors[randi_range(0, colors.size() - 1)]
		background.color = c

func set_data(data: RuleData):
	text.text = data.text
