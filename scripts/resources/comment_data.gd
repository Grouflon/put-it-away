extends Resource
class_name CommentData

@export var avatar: Texture2D
@export var author: String
@export var body: String
@export var comment_script: GDScript

func is_valid(script: CommentScript) -> bool:
	if script != null:
		return script.is_valid()
	return true

func get_avatar(script: CommentScript) -> Texture2D:
	var result: Texture2D
	if script != null:
		result = script.get_avatar()
	if result == null:
		result = avatar
	return result	

func get_author(script: CommentScript) -> String:
	var result: String
	if script != null:
		result = script.get_author()
	if result == "":
		result = author
	return result
	
func get_body(script: CommentScript) -> String:
	var result: String
	if script != null:
		result = script.get_body()
	if result == "":
		result = body
	return result	
