extends CommentScript

# Retourner true si le commentaire peut être affiché
func is_valid(_day_result: DayResult) -> bool:
	return true

# Le contenu du commentaire
func get_body() -> String:
	return "C'est moi qui a mis la banane dans la boîte aux lettres lol"

# L'auteurice du commentaire
func get_author() -> String:
	return "@zertzo"

# L'avatar du commentaire
func get_avatar() -> Texture2D:
	return null
