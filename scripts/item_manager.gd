extends Node
class_name ItemManager

var items: Array[Item]
var dragged_item: Item
var drag_offset: Vector2
var drag_enabled: bool = true

signal item_dropped(item: Item)

func set_drag_enabled(value: bool):
	if value == drag_enabled: return
	
	drag_enabled = value
	if !drag_enabled:
		drop_dragged_item()

func initialize():
	update_items_z()

func process(input: InputData):
	if !drag_enabled: return
	
	var hovered_item: Item
	if input.topmost_hovered_object is Item:
		hovered_item = input.topmost_hovered_object
	
	if dragged_item == null && input.interact_just_pressed:
		if hovered_item != null:
			# acquire dragged item
			move_item_on_top(hovered_item)
			dragged_item = hovered_item
			drag_offset = input.mouse_position - dragged_item.position
			
	if dragged_item != null && !input.interact_down:
		drop_dragged_item()
		
	if dragged_item != null && tools.point_cast_z_ordered_first(input.mouse_position, 2) != null:
		dragged_item.position = input.mouse_position - drag_offset

func move_item_on_top(item: Item):
	var found = tools.remove_from_array(items, item)
	assert(found)
	items.push_back(item)
	update_items_z()
	
func drop_dragged_item():
	if dragged_item == null: return
	var dropped_item = dragged_item
	dragged_item = null
	drag_offset = Vector2.ZERO
	item_dropped.emit(dropped_item)

func update_items_z():
	var z = 0
	for item in items:
		item.z_index = z
		z += 1
		
func register_item(item: Item):
	assert(!items.has(item))
	items.append(item)
	update_items_z()
	
func unregister_item(item: Item):
	var found = tools.remove_from_array(items, item)
	assert(found)
	update_items_z()
