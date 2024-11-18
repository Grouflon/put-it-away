extends Node
class_name GameCore

var items: Array[Item]
var hovered_items: Array[Item]
var dragged_item: Item
var drag_offset: Vector2

func _ready() -> void:
	fetch_items($"/root", items)
	update_items_z()	

func _process(delta: float) -> void:
	var interact = Input.is_action_pressed("Interact")
	var mouse_position = get_viewport().get_mouse_position()
	
	if interact:
		if dragged_item == null:
			var topmost_item: Item
			var topmost_z: int = -99999
			for item in hovered_items:
				if item.z_index > topmost_z:
					topmost_z = item.z_index
					topmost_item = item
		
			if topmost_item != null:
				# acquire dragged item
				dragged_item = topmost_item
				drag_offset = mouse_position - dragged_item.position
				var found = tools.remove_from_array(items, dragged_item)
				assert(found)
				items.push_back(dragged_item)
				update_items_z()
	else:
		# lose dragged item
		dragged_item = null
		drag_offset = Vector2.ZERO
		
	if dragged_item != null:
		dragged_item.position = mouse_position - drag_offset

func notify_mouse_entered_item(item: Item):
	assert(!hovered_items.has(item))
	hovered_items.append(item)
	pass
	
func notify_mouse_exited_item(item: Item):
	var found = tools.remove_from_array(hovered_items, item)
	assert(found)

func update_items_z():
	var z = 0
	for item in items:
		item.z_index = z
		z += 1
	
func fetch_items(node: Node, results: Array[Item]):
	if node is Item:
		results.push_back(node)
	for child in node.get_children():
		fetch_items(child, results)
