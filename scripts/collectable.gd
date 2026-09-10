extends Node
class_name Collectable

@export var item: Node2D
var item_type: Constants.Item

func try_collect():
	if item_type != null:
		SignalBus.item_collected.emit(self, item)

func on_collected():
	item.queue_free()
