extends GutTest
## Integrity checks on the item/recipe tables.
##
## Item data lives in three places keyed by the same enum (Item, ITEM_NAME,
## ITEM_ICON), so adding an item and forgetting one of them is easy and
## otherwise only shows up as a crash mid-game. These tests catch that.

func _real_items() -> Array:
	var items := Constants.Item.values()
	items.erase(Constants.Item.NONE)
	return items


# --- item tables -----------------------------------------------------------

func test_every_item_has_a_name() -> void:
	for item in _real_items():
		assert_true(Constants.ITEM_NAME.has(item),
			"Item %d is missing from ITEM_NAME" % item)

func test_every_item_has_an_icon() -> void:
	for item in _real_items():
		assert_true(Constants.ITEM_ICON.has(item),
			"Item %d is missing from ITEM_ICON" % item)
		assert_not_null(Constants.ITEM_ICON.get(item),
			"Item %d has a null icon" % item)

func test_item_names_are_unique() -> void:
	var names := Constants.ITEM_NAME.values()
	assert_eq(names.size(), _dedupe(names).size(), "two items share a display name")

func test_none_is_not_a_real_item() -> void:
	assert_false(Constants.ITEM_NAME.has(Constants.Item.NONE))
	assert_false(Constants.ITEM_ICON.has(Constants.Item.NONE))


# --- recipes ---------------------------------------------------------------

func test_recipes_only_reference_known_items() -> void:
	for recipe in Constants.RECIPES:
		assert_true(Constants.ITEM_NAME.has(recipe["output"]),
			"recipe output %d is not a known item" % recipe["output"])
		for ingredient in recipe["inputs"]:
			assert_true(Constants.ITEM_NAME.has(ingredient),
				"recipe ingredient %d is not a known item" % ingredient)

func test_recipes_never_use_none() -> void:
	for recipe in Constants.RECIPES:
		assert_ne(recipe["output"], Constants.Item.NONE)
		assert_false(recipe["inputs"].has(Constants.Item.NONE))

func test_recipes_ask_for_positive_amounts() -> void:
	for recipe in Constants.RECIPES:
		assert_gt(recipe["inputs"].size(), 0, "a recipe needs at least one ingredient")
		for ingredient in recipe["inputs"]:
			assert_gt(recipe["inputs"][ingredient], 0)

func test_each_recipe_makes_something_different() -> void:
	# The cauldron labels each row with ITEM_NAME[output], so duplicate
	# outputs would render as two identical-looking rows.
	var outputs := []
	for recipe in Constants.RECIPES:
		outputs.append(recipe["output"])
	assert_eq(outputs.size(), _dedupe(outputs).size(), "two recipes share an output")

func test_a_recipe_never_produces_its_own_ingredient() -> void:
	for recipe in Constants.RECIPES:
		assert_false(recipe["inputs"].has(recipe["output"]),
			"%s is brewed from itself" % Constants.ITEM_NAME[recipe["output"]])


func _dedupe(values: Array) -> Array:
	var seen := []
	for v in values:
		if not seen.has(v):
			seen.append(v)
	return seen
