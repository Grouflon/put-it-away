extends CommentScript

enum Quantity
{
	NONE,
	FEW,
	SOME,
	ALOT,
}
var quantity: Quantity = Quantity.NONE

func is_valid(day_result: DayResult) -> bool:
	var books := day_result.total_stored_items.filter(func(item): return item is Book)
	var nbOfBooks := books.size()
	
	if nbOfBooks >= 10:
		quantity = Quantity.ALOT
		return true
		
	if nbOfBooks >= 5:
		quantity = Quantity.SOME
		return true
		
	if nbOfBooks >= 1:
		quantity = Quantity.FEW
		return true
		
	if nbOfBooks <= 0:
		quantity = Quantity.NONE
		return true

	return false

func get_body() -> String:
	match quantity:
		Quantity.ALOT:
			return "Il y a tellement de livres dans cette bibliothèque. On peut trouver n'importe quoi. J'adore !!!"
		Quantity.SOME:
			return "On trouve pas mal de livre ici, mais le catalogue pourrait être encore plus fourni."
		Quantity.FEW:
			return "Cette bibliothèque est quasi vide. Ne vous embêtez pas à y mettre les pieds."
		Quantity.NONE:
			return "Wtf où sont les livres ???"
	return ""

func get_author() -> String:
	return "@caroline_booklover"

#func get_avatar() -> Texture2D:
	#return null
#
