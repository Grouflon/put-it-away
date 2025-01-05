extends Node2D
class_name GameTools

func remove_from_array(array: Array, item) -> bool:
	var i = array.find(item)
	if i < 0: return false
	array.remove_at(i)
	return true
	
func compute_global_z_index(node: Node2D) -> int:
	if node == null: return 0
	var z = node.z_index
	
	var parent: Node2D
	if node.get_parent() is Node2D:
		parent = node.get_parent()
	
	if node.z_as_relative && parent != null:
		z += compute_global_z_index(parent)
	return z

func point_cast_z_ordered(point: Vector2, collision_mask: int = 0xFFFFFFFF) -> Array[Node2D]:
	var params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.position = point
	params.collision_mask = collision_mask
	var intersections = get_world_2d().direct_space_state.intersect_point(params)
	
	var results: Array[Node2D]
	for intersection in intersections:
		var node: Node2D = intersection.collider
		if node == null: continue
		
		var i = 0
		for result in results:
			if tools.compute_global_z_index(node) >= tools.compute_global_z_index(result):
				break
			i += 1
		results.insert(i, node)
		
	return results

func point_cast_z_ordered_first(point: Vector2, collision_mask: int = 0xFFFFFFFF) -> Node2D:
	var result: = point_cast_z_ordered(point, collision_mask)
	if result.size() > 0:
		return result[0]
	return null
