extends Item
class_name Book

@export var start_data: BookData

@export_group("layout")
@export var background: ColorRect
@export var title: Label
@export var author: Label
@export var date: Label
@export var condition: Label

func _ready():
	if start_data != null:
		set_data(start_data)

func set_data(data: BookData):
	if data == null:
		return
	
	background.color = data.color
	title.text = data.title
	author.text = data.author
	date.text = str(data.year_of_publication)
	condition.text = condition_to_string(data.condition)
	
func condition_to_string(book_condition: BookData.Condition):
	match book_condition:
		BookData.Condition.EXCELLENT: return "X"
		BookData.Condition.GOOD: return "XX"
		BookData.Condition.USED: return "XXX"
		BookData.Condition.DAMAGED: return "XXXX"
	return ""
