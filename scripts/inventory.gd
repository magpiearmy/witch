extends Node
## Autoload. The player's satchel: a flat list of item stacks.
## Rendered by InventoryHud (always-on quick view of the first few) and
## InventoryPanel (the full grid, toggled with the "inventory" action).

const CAPACITY := 12

## Each entry: {"type": Constants.Item, "amount": int}
var stacks: Array[Dictionary] = []

signal changed

func _ready() -> void:
	SignalBus.item_collected.connect(_on_item_collected)

func _on_item_collected(collectable, node) -> void:
	if add(collectable.item_type):
		SignalBus.collect_successful.emit(node)
		collectable.on_collected()
	else:
		SignalBus.collect_failed.emit()

func _index_of(type: Constants.Item) -> int:
	for i in stacks.size():
		if stacks[i]["type"] == type:
			return i
	return -1

func count(type: Constants.Item) -> int:
	var i := _index_of(type)
	return stacks[i]["amount"] if i != -1 else 0

## Add items, stacking onto an existing pile. False only when a new
## stack is needed and the satchel is full.
func add(type: Constants.Item, amount := 1) -> bool:
	var i := _index_of(type)
	if i != -1:
		stacks[i]["amount"] += amount
		changed.emit()
		return true
	if stacks.size() >= CAPACITY:
		return false
	stacks.append({"type": type, "amount": amount})
	changed.emit()
	return true

## Alias for add(), kept for the cauldron's read-as-prose call sites.
func give(type: Constants.Item, amount := 1) -> bool:
	return add(type, amount)

## True when every ingredient in `inputs` (Item -> count) is in stock.
func can_craft(inputs: Dictionary) -> bool:
	for type in inputs:
		if count(type) < inputs[type]:
			return false
	return true

## Remove the ingredients listed in `inputs`. Assumes can_craft() passed.
func take(inputs: Dictionary) -> void:
	for type in inputs:
		var i := _index_of(type)
		if i == -1:
			continue
		stacks[i]["amount"] -= inputs[type]
		if stacks[i]["amount"] <= 0:
			stacks.remove_at(i)
	changed.emit()

## Push the current contents into an array of InventorySlot views.
func render_into(slots: Array) -> void:
	for i in slots.size():
		if i < stacks.size():
			slots[i].render(stacks[i]["type"], stacks[i]["amount"])
		else:
			slots[i].render(-1, 0)
