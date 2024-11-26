extends CommentScript

func can_show_comment() -> bool:
	for item in core.today_kept_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.condition == BookData.Condition.DAMAGED:
			return true
		
	return false

func get_comment_body() -> String:
	return "Certains livres sont dans un état qui laisse à désirer."

func get_comment_author() -> String:
	return "Un usager"
