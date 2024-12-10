extends CommentScript

func is_valid(day_result: DayResult) -> bool:
	for item in day_result.today_stored_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.condition == BookData.Condition.DAMAGED:
			return true
		
	return false

func get_body() -> String:
	return "Certains livres sont dans un état qui laisse à désirer."

func get_author() -> String:
	return "@un_usager"

#func get_avatar() -> Texture2D:
	#return null
#
