extends Control

@onready var slots = [
	$MarginContainer/HBoxContainer/Slot1,
	$MarginContainer/HBoxContainer/Slot2,
	$MarginContainer/HBoxContainer/Slot3
]

func _ready():
	add_to_group("inventory")
	SignalBus.item_collected.connect(try_collect)

func try_collect(item: Collectable, node: Node2D):
	for slot in slots:
		if slot.accept(item, node):
			SignalBus.collect_successful.emit(node)
			item.on_collected()
			return
	SignalBus.collect_failed.emit()

# --- brewing API ----------------------------------------------------------

func count(item_type: Constants.Item) -> int:
	var total := 0
	for slot in slots:
		if slot.is_set and slot.item_type == item_type:
			total += slot.amount
	return total

## True when every ingredient in `inputs` (Item -> count) is in stock.
func can_craft(inputs: Dictionary) -> bool:
	for item_type in inputs:
		if count(item_type) < inputs[item_type]:
			return false
	return true

## Remove the ingredients listed in `inputs`. Assumes can_craft() passed.
func take(inputs: Dictionary) -> void:
	for item_type in inputs:
		var remaining: int = inputs[item_type]
		for slot in slots:
			if remaining <= 0:
				break
			if slot.is_set and slot.item_type == item_type:
				var taken: int = min(slot.amount, remaining)
				slot.remove(taken)
				remaining -= taken

## Add `amount` of `item_type`, stacking first. False when the bag is full.
func give(item_type: Constants.Item, amount := 1) -> bool:
	for slot in slots:
		if slot.is_set and slot.item_type == item_type:
			slot.add_type(item_type, amount)
			return true
	for slot in slots:
		if not slot.is_set:
			slot.add_type(item_type, amount)
			return true
	return false
