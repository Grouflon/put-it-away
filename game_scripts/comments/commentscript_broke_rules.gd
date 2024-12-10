extends CommentScript

enum Severity
{
	NONE,
	LIGHT,
	HEAVY
}
var severity: Severity = Severity.NONE

func is_valid(day_result: DayResult) -> bool:
	
	if day_result.today_broken_rules >= 3:
		severity = Severity.HEAVY
		return true
		
	if day_result.today_broken_rules >= 1:
		severity = Severity.LIGHT
		return true

	return false

func get_body() -> String:
	match severity:
		Severity.HEAVY:
			return "Je vais vous placardiser."
		Severity.LIGHT:
			return "Attention, si vous continuez comme ça, on va dire que le service public c’est de la merde."	
	return ""

func get_author() -> String:
	return "@directeur"

#func get_avatar() -> Texture2D:
	#return null
#
