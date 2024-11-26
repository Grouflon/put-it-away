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
	apply_data(data)

func apply_data(_data: BookData):
	if _data == null:
		return
	
	background.color = _data.color
	title.text = _data.title
	author.text = _data.author
	date.text = str(_data.year_of_publication)
	condition.text = condition_to_string(_data.condition)
	
func condition_to_string(book_condition: BookData.Condition):
	match book_condition:
		BookData.Condition.EXCELLENT: return "X"
		BookData.Condition.GOOD: return "XX"
		BookData.Condition.USED: return "XXX"
		BookData.Condition.DAMAGED: return "XXXX"
	return ""
