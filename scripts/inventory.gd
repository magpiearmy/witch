extends Control

@onready var slots = [
	$MarginContainer/HBoxContainer/Slot1,
	$MarginContainer/HBoxContainer/Slot2,
	$MarginContainer/HBoxContainer/Slot3
]

func _ready():
	SignalBus.on_item_collect.connect(on_collected)

func on_collected(item: Collectable, node: Node2D):
	for slot in slots:
		if slot.accept(item, node):
			item.on_collected()
			SignalBus.on_collect_success.emit()
			return
	SignalBus.on_collect_fail.emit()
