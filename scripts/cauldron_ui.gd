extends Control
## Opened by SignalBus.cauldron_opened (main.gd freezes the overworld at the same time).
## Lists every recipe in Constants.RECIPES and brews the affordable ones,
## drawing ingredients from and returning results to the inventory.

const BREW_TIME := 1.2

@onready var _list: VBoxContainer = $Center/Panel/Margin/VBox/RecipeList
@onready var _cauldron: TextureRect = $Center/Panel/Margin/VBox/Cauldron
@onready var _pop: AudioStreamPlayer = $Pop

var _inventory: Node
var _brewing := false
var _bubble_tween: Tween

func _ready() -> void:
	hide()
	SignalBus.cauldron_opened.connect(_open)

func _open() -> void:
	_inventory = get_tree().get_first_node_in_group("inventory")
	if _inventory == null:
		return
	_rebuild()
	show()

func _close() -> void:
	hide()
	SignalBus.cauldron_closed.emit()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("cancel"):
		_close()
		get_viewport().set_input_as_handled()

func _rebuild() -> void:
	for row in _list.get_children():
		row.hide()
		row.queue_free()
	for recipe in Constants.RECIPES:
		_list.add_child(_make_row(recipe))

func _make_row(recipe: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var inputs := HBoxContainer.new()
	inputs.add_theme_constant_override("separation", 4)
	inputs.custom_minimum_size.x = 160
	inputs.alignment = BoxContainer.ALIGNMENT_END
	for item_type in recipe["inputs"]:
		inputs.add_child(_chip(item_type, "%d" % recipe["inputs"][item_type]))
	row.add_child(inputs)

	row.add_child(_text("→"))
	row.add_child(_chip(recipe["output"], ""))

	var name_label := _text(Constants.ITEM_NAME[recipe["output"]])
	name_label.custom_minimum_size.x = 150
	row.add_child(name_label)

	var brew := Button.new()
	brew.text = "Brew"
	brew.focus_mode = Control.FOCUS_NONE
	brew.disabled = _brewing or not _inventory.can_craft(recipe["inputs"])
	brew.pressed.connect(_brew.bind(recipe))
	row.add_child(brew)
	return row

func _chip(item_type: Constants.Item, label: String) -> Control:
	var chip := ColorRect.new()
	chip.color = Constants.ITEM_COLOR[item_type]
	chip.custom_minimum_size = Vector2(46, 46)
	chip.tooltip_text = Constants.ITEM_NAME[item_type]
	if label != "":
		var l := Label.new()
		l.text = label
		l.set_anchors_preset(Control.PRESET_FULL_RECT)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.add_theme_color_override("font_color", Color.WHITE)
		l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
		l.add_theme_constant_override("outline_size", 4)
		chip.add_child(l)
	return chip

func _text(s: String) -> Label:
	var l := Label.new()
	l.text = s
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_color", Color("4a3520"))
	return l

func _brew(recipe: Dictionary) -> void:
	if _brewing or not _inventory.can_craft(recipe["inputs"]):
		return
	_brewing = true
	_inventory.take(recipe["inputs"])
	_rebuild()
	_start_bubbling()

	await get_tree().create_timer(BREW_TIME).timeout

	if not _inventory.give(recipe["output"], 1):
		# bag filled up mid-brew: hand the ingredients back
		for item_type in recipe["inputs"]:
			_inventory.give(item_type, recipe["inputs"][item_type])
	else:
		_pop.play()

	_stop_bubbling()
	_brewing = false
	if visible:
		_rebuild()

func _start_bubbling() -> void:
	_bubble_tween = create_tween().set_loops()
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(1.06, 0.94), 0.18)
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(0.96, 1.05), 0.22)
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(1, 1), 0.18)

func _stop_bubbling() -> void:
	if _bubble_tween:
		_bubble_tween.kill()
	_cauldron.scale = Vector2.ONE
