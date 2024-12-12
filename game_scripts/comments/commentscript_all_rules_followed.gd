extends CommentScript

# Retourner true si le commentaire peut être affiché
func is_valid(_day_result: DayResult) -> bool:
	
	if _day_result.today_broken_rules <= 0:
		return true
		

	return false

# Le contenu du commentaire
func get_body() -> String:
	return "Un excellent travail de notre nouvel employé de la bibliothèque."

# L'auteurice du commentaire
func get_author() -> String:
	return "@your_work_husband"

# L'avatar du commentaire
func get_avatar() -> Texture2D:
	return null
