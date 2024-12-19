extends RuleScript

func check_rule(day_result: DayResult) -> bool:
	for item in day_result.today_stored_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.year_of_publication < 1945:
			return false
		
	return true

func get_text() -> String:
	return "Uniquement les livres après 1945"
