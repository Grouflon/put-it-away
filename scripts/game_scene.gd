extends Node2D
class_name GameScene

@export var animation_player: AnimationPlayer
@export var day_text: RichTextLabel
@export var book_box: BookBox
@export var keep_zone: Node2D
@export var ditch_zone: Node2D

func point_cast_z_ordered(position: Vector2) -> Array[Node2D]:
	var params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.position = position
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
