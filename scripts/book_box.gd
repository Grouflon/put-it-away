extends Node
class_name BookBox

@export var text: RichTextLabel

var text_format_string: String
var initialized: bool # hack to work around shitty ready order thing

func initialize():
	if initialized: return
	text_format_string = text.text
	initialized = true

func update_item_count(item_count: int):
	initialize()
	text.text = text_format_string.format({"item_count": item_count})
