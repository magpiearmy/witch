extends Control
## Always-on quick view: the first few satchel stacks, bottom-left.
## Press the "inventory" action to see everything (InventoryPanel).

@onready var _slots := [
	$Margin/Row/Slot1,
	$Margin/Row/Slot2,
	$Margin/Row/Slot3,
]

func _ready() -> void:
	Inventory.changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	Inventory.render_into(_slots)
