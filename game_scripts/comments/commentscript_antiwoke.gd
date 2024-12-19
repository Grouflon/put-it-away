extends CommentScript

# Retourner true si le commentaire peut être affiché
func is_valid(day_result: DayResult) -> bool:
	var nbOfWoke: int = 0
	for item in day_result.total_stored_items:
		var book: Book = item as Book
		if book == null: continue
		
		if "Woke" in book.data.tags:
				nbOfWoke += 1
		
		if nbOfWoke >= 3:
			return true
	
	return false

# Le contenu du commentaire
func get_body() -> String:
	return "Bibliothèque de wokiste ! Je vais couper les subventions."

# L'auteurice du commentaire
func get_author() -> String:
	return "@lemaire"

# L'avatar du commentaire
func get_avatar() -> Texture2D:
	return null
