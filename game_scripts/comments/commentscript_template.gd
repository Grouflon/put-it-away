extends CommentScript

# Retourner true si le commentaire peut être affiché
func is_valid(_day_result: DayResult) -> bool:
	return true

# Le contenu du commentaire
func get_body() -> String:
	return "J'adore ce que vous faites."

# L'auteurice du commentaire
func get_author() -> String:
	return "@michel"

# L'avatar du commentaire
func get_avatar() -> Texture2D:
	return null
