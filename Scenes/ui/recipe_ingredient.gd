extends Control
## An item icon in a cauldron recipe row. Purely a view: the owning
## RecipeUI calls render() after adding it to the tree, and sets `clickable`
## on a recipe's output so it can be clicked to brew.

signal clicked

@export var hover_color := Color(0.87, 0.74, 0.56, 1)

@onready var _background: ColorRect = $MarginContainer/BackgroundContainer/Background
@onready var _icon: TextureRect = $MarginContainer/IconContainer/Icon
@onready var _label: Label = $Label
@onready var _base_color := _background.color

## When true the icon shades on hover, shows a hand cursor and emits `clicked`.
var clickable := false:
	set(value):
		clickable = value
		mouse_default_cursor_shape = CURSOR_POINTING_HAND if value else CURSOR_ARROW
		_update_shade()

var _hovered := false

func _ready() -> void:
	mouse_entered.connect(_set_hovered.bind(true))
	mouse_exited.connect(_set_hovered.bind(false))

func _gui_input(event: InputEvent) -> void:
	if clickable and event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		clicked.emit()

## `count` is shown as a corner badge when above 0; pass 0 for no badge
## (e.g. a recipe's output).
func render(type: Constants.Item, count: int) -> void:
	_icon.visible = true
	_icon.texture = Constants.ITEM_ICON[type]
	tooltip_text = Constants.ITEM_NAME[type]
	_label.text = str(count) if count > 0 else ""

func _set_hovered(hovered: bool) -> void:
	_hovered = hovered
	_update_shade()

func _update_shade() -> void:
	if is_node_ready():
		_background.color = hover_color if clickable and _hovered else _base_color
