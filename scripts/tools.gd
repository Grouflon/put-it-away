extends Node
class_name GameTools

func remove_from_array(array: Array, item) -> bool:
	var i = array.find(item)
	if i < 0: return false
	array.remove_at(i)
	return true
	
func compute_global_z_index(node: Node2D) -> int:
	if node == null: return 0
	var z_index = node.z_index
	
	var parent: Node2D
	if node.get_parent() is Node2D:
		parent = node.get_parent()
	
	if node.z_as_relative && parent != null:
		z_index += compute_global_z_index(parent)
	return z_index
