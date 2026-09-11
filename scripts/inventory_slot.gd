extends Control
## A single satchel cell. Purely a view: Inventory owns the data and calls
## render() to update it.

@onready var _icon: TextureRect = $Icon
@onready var _label: Label = $Label

## `type` is a Constants.Item; Item.NONE with amount 0 means an empty cell.
func render(type: Constants.Item, amount: int) -> void:
	if amount > 0:
		_icon.visible = true
		_icon.texture = Constants.ITEM_ICON[type]
		_label.text = str(amount) if amount > 1 else ""
	else:
		_icon.visible = false
		_icon.texture = null
		_label.text = ""
