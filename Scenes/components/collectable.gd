extends Node
class_name Collectable

@export var item: Node2D
var item_type := Constants.Item.NONE

func try_collect() -> void:
	if item_type == Constants.Item.NONE:
		push_warning("Collectable on %s has no item_type set" % item)
		return
	SignalBus.item_collected.emit(self, item)

func on_collected():
	item.queue_free()
