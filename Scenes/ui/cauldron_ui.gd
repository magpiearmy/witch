extends Control
## Opened by SignalBus.cauldron_opened (main.gd freezes the overworld at the same time).
## Lists every recipe in Constants.RECIPES and brews the affordable ones,
## drawing ingredients from and returning results to the Inventory.

const BREW_TIME := 1.2
const RECIPE_SCENE := preload("res://scenes/ui/recipe_ui.tscn")

@onready var _list: VBoxContainer = $Center/Panel/Margin/VBox/RecipeList
@onready var _cauldron: TextureRect = $Center/Panel/Margin/VBox/Cauldron
@onready var _pop: AudioStreamPlayer = $Pop

var _rows: Array = []
var _brewing := false
var _bubble_tween: Tween

func _ready() -> void:
	hide()
	for recipe in Constants.RECIPES:
		var row := RECIPE_SCENE.instantiate()
		_list.add_child(row)
		row.setup(recipe)
		row.brew_pressed.connect(_brew)
		_rows.append(row)
	SignalBus.cauldron_opened.connect(_open)

func _open() -> void:
	_refresh()
	show()

func _close() -> void:
	hide()
	SignalBus.cauldron_closed.emit()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("cancel"):
		_close()
		get_viewport().set_input_as_handled()

func _refresh() -> void:
	for i in _rows.size():
		_rows[i].set_brewable(not _brewing and Inventory.can_craft(Constants.RECIPES[i]["inputs"]))

func _brew(recipe: Dictionary) -> void:
	if _brewing or not Inventory.can_craft(recipe["inputs"]):
		return
	_brewing = true
	Inventory.take(recipe["inputs"])
	_refresh()
	_start_bubbling()

	await get_tree().create_timer(BREW_TIME).timeout

	if not Inventory.give(recipe["output"], 1):
		# satchel filled up mid-brew: hand the ingredients back
		for item_type in recipe["inputs"]:
			Inventory.give(item_type, recipe["inputs"][item_type])
	else:
		_pop.play()

	_stop_bubbling()
	_brewing = false
	if visible:
		_refresh()

func _start_bubbling() -> void:
	_bubble_tween = create_tween().set_loops()
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(1.06, 0.94), 0.18)
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(0.96, 1.05), 0.22)
	_bubble_tween.tween_property(_cauldron, "scale", Vector2(1, 1), 0.18)

func _stop_bubbling() -> void:
	if _bubble_tween:
		_bubble_tween.kill()
	_cauldron.scale = Vector2.ONE
