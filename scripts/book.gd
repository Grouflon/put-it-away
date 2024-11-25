extends Item
class_name Book

@export var data: BookData

@export_group("layout")
@export var background: ColorRect
@export var title: Label
@export var author: Label
@export var date: Label
@export var condition: Label

func _ready():
	if data != null:
		set_data(data)

func set_data(data: BookData):
	if data == null:
		return
	
	background.color = data.color
	title.text = data.title
	author.text = data.author
	date.text = str(data.year_of_publication)
	condition.text = condition_to_string(data.condition)
	
func condition_to_string(condition: BookData.Condition):
	match condition:
		BookData.Condition.EXCELLENT: return "X"
		BookData.Condition.GOOD: return "XX"
		BookData.Condition.USED: return "XXX"
		BookData.Condition.DAMAGED: return "XXXX"
	return ""
