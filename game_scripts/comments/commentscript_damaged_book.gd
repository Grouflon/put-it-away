extends CommentScript

func is_valid() -> bool:
	for item in core.today_kept_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.condition == BookData.Condition.DAMAGED:
			return true
		
	return false

#func get_avatar() -> Texture2D:
	#return null
#
#func get_body() -> String:
	#return ""
#
#func get_author() -> String:
	#return ""
