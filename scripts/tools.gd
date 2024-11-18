extends Node
class_name GameTools

func remove_from_array(array: Array, item) -> bool:
	var i = array.find(item)
	if i < 0: return false
	array.remove_at(i)
	return true
