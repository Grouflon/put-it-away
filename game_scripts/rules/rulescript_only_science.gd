extends RuleScript

# Retourner true si la règle a été suivie
func check_rule(day_result: DayResult) -> bool:
	for item in day_result.today_stored_items:
		var book: Book = item as Book
		if book == null: continue
		
		if book.data.category != BookData.Category.SCIENCE :
			return false
		
	return true

# Le texte du post-it
func get_text() -> String:
	return "Accepter uniquement les dons de livres scientifiques"
