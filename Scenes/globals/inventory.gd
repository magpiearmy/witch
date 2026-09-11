extends Node
## Autoload. The player's satchel: one stack per item type.
## Rendered by InventoryHud (always-on quick view of the first few) and
## InventoryPanel (the full grid, toggled with the "inventory" action).

const CAPACITY := 9

## How many of each item is held. Dictionaries keep insertion order, so this
## doubles as the slot order the views draw, oldest find first.
var stacks: Dictionary[Constants.Item, int] = {}

signal changed

func _ready() -> void:
	SignalBus.item_collected.connect(_on_item_collected)

func _on_item_collected(collectable: Collectable, item: Node2D) -> void:
	if add(collectable.item_type):
		SignalBus.collect_successful.emit(item)
		collectable.on_collected()
	else:
		SignalBus.collect_failed.emit()

func count(type: Constants.Item) -> int:
	return stacks.get(type, 0)

## A new item type has nowhere to go. An item already held always stacks.
func is_full() -> bool:
	return stacks.size() >= CAPACITY

## Add items, stacking onto an existing pile. False only when a new stack is
## needed and the satchel is full.
func add(type: Constants.Item, amount := 1) -> bool:
	if not stacks.has(type):
		if is_full():
			return false
		stacks[type] = 0
	stacks[type] += amount
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

## Remove the ingredients listed in `inputs`. Call can_craft() first.
func take(inputs: Dictionary) -> void:
	assert(can_craft(inputs), "take() called for ingredients that aren't in stock")
	var took_something := false
	for type in inputs:
		if not stacks.has(type):
			continue
		stacks[type] -= inputs[type]
		if stacks[type] <= 0:
			stacks.erase(type)
		took_something = true
	if took_something:
		changed.emit()

## Push the current contents into an array of InventorySlot views.
func render_into(slots: Array) -> void:
	var types := stacks.keys()
	for i in slots.size():
		if i < types.size():
			slots[i].render(types[i], stacks[types[i]])
		else:
			slots[i].render(Constants.Item.NONE, 0)
