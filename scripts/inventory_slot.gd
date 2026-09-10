extends Control
## A single satchel cell. Purely a view: Inventory owns the data and calls
## render() to update it.

@onready var _swatch: ColorRect = $Swatch
@onready var _label: Label = $Label

## `type` is a Constants.Item, or -1 (with amount 0) for an empty cell.
func render(type: int, amount: int) -> void:
	if amount > 0:
		_swatch.visible = true
		_swatch.color = Constants.ITEM_COLOR[type]
		_label.text = str(amount) if amount > 1 else ""
	else:
		_swatch.visible = false
		_label.text = ""
