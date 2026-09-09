extends Control

@onready var slots = [
	$MarginContainer/HBoxContainer/Slot1,
	$MarginContainer/HBoxContainer/Slot2,
	$MarginContainer/HBoxContainer/Slot3
]

func _ready():
	SignalBus.on_item_collect.connect(try_collect)

func try_collect(item: Collectable, node: Node2D):
	for slot in slots:
		if slot.accept(item, node):
			SignalBus.on_collect_success.emit(node)
			item.on_collected()
			return
	SignalBus.on_collect_fail.emit()
