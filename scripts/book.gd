extends Item
class_name Book

@export var background: ColorRect
@export var title: RichTextLabel
@export var author: RichTextLabel
@export var date: RichTextLabel
@export var condition: RichTextLabel

@export var base_data: BookData

var title_format_string: String
var author_format_string: String
var date_format_string: String
var condition_format_string: String

func _ready():
	super()
	
	title_format_string = title.text
	author_format_string = author.text
	date_format_string = date.text
	condition_format_string = condition.text
	
	if base_data != null:
		set_data(base_data)
	

func set_data(data: BookData):
	if data == null:
		return
	
	background.color = data.color
	title.text = title_format_string.format({"title": data.title})
	author.text = author_format_string.format({"author": data.author})
	date.text = date_format_string.format({"date": data.year_of_publication})
	condition.text = condition_format_string.format({"condition": condition_to_string(data.condition)})
	
func condition_to_string(condition: BookData.Condition):
	match condition:
		BookData.Condition.EXCELLENT: return "X"
		BookData.Condition.GOOD: return "XX"
		BookData.Condition.USED: return "XXX"
		BookData.Condition.DAMAGED: return "XXXX"
	return ""
