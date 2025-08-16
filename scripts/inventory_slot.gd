extends Control

var item_type: Constants.Item
var is_set: bool = false
var amount = 0

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
	
func increment():
	amount += 1
	count_label.text = str(amount)
