extends Control

var item_type: Constants.Item
var is_set: bool = false
var amount = 0
var _visual: Node

@onready var count_label = $Label

func accept(item: Collectable, node: Node2D) -> bool:
	if !is_set:
		is_set = true
		self.item_type = item.item_type
		add_item_scene(node)
		increment()
		return true
	elif item.item_type == self.item_type:
		increment()
		return true
	else:
		return false

func add_item_scene(node: Node2D):
	var new_node = node.duplicate(0)
	new_node.position = Vector2(64, 64)
	$MarginContainer.add_child(new_node)
	_visual = new_node

func increment():
	amount += 1
	count_label.text = str(amount)

# --- brewing support -------------------------------------------------------

## Add a brewed item (no world node to clone) as a flat colour block.
func add_type(new_type: Constants.Item, count: int) -> void:
	if !is_set:
		is_set = true
		item_type = new_type
		var swatch := Polygon2D.new()
		swatch.polygon = PackedVector2Array([
			Vector2(-36, -36), Vector2(36, -36), Vector2(36, 36), Vector2(-36, 36)
		])
		swatch.color = Constants.ITEM_COLOR[new_type]
		swatch.position = Vector2(64, 64)
		$MarginContainer.add_child(swatch)
		_visual = swatch
	amount += count
	count_label.text = str(amount)

## Remove `count` items; empties the slot when it hits zero.
func remove(count: int) -> void:
	amount -= count
	if amount <= 0:
		clear()
	else:
		count_label.text = str(amount)

func clear() -> void:
	is_set = false
	amount = 0
	if is_instance_valid(_visual):
		_visual.queue_free()
	_visual = null
	count_label.text = ""
