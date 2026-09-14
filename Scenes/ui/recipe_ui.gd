extends HBoxContainer
## One recipe row in the cauldron: ingredients -> output, name. Clicking the
## output icon brews the recipe.
## CauldronUI calls setup() once after adding it to the tree, then
## set_brewable() whenever the inventory or brewing state changes.

signal brew_pressed(recipe: Dictionary)

const INGREDIENT_SCENE := preload("res://scenes/ui/recipe_ingredient.tscn")
const UNBREWABLE_ALPHA := 0.5

@onready var _inputs: HBoxContainer = $InputsContainer
@onready var _output = $Output
@onready var _name: Label = $Name

var _recipe: Dictionary

func setup(recipe: Dictionary) -> void:
	_recipe = recipe
	for item_type in recipe["inputs"]:
		var ingredient := INGREDIENT_SCENE.instantiate()
		_inputs.add_child(ingredient)
		ingredient.render(item_type, recipe["inputs"][item_type])
	_output.render(recipe["output"], 0)
	_name.text = Constants.ITEM_NAME[recipe["output"]]
	_output.clicked.connect(func() -> void: brew_pressed.emit(_recipe))

func set_brewable(brewable: bool) -> void:
	_output.clickable = brewable
	_output.modulate.a = 1.0 if brewable else UNBREWABLE_ALPHA
