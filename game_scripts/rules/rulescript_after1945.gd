extends RuleScript

func check_rule() -> bool:
	for item in core.today_kept_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.year_of_publication < 1945:
			return false
		
	return true
