extends Node

enum FruitType {BLUE, PURPLE, RED}

enum Item {
	## Default for an unassigned item_type, so "never set" is distinguishable
	## from a real item. Never appears in the satchel or a recipe.
	NONE,
	RED_FRUIT,
	BLUE_FRUIT,
	PURPLE_FRUIT,
	PINK_BERRIES,
	BLACK_BERRIES,
	YELLOW_HONEY,
	ORANGE_HONEY,
	SUGAR_CANE,
	# brewed at the cauldron
	RED_JUICE,
	BERRY_JAM,
	GRAPE_CORDIAL,
	FRUIT_PUNCH,
	BERRY_TONIC,
}

var ITEM_NAME := {
	Item.RED_FRUIT: "Red Fruit",
	Item.BLUE_FRUIT: "Blue Fruit",
	Item.PURPLE_FRUIT: "Purple Fruit",
	Item.PINK_BERRIES: "Pink Berries",
	Item.BLACK_BERRIES: "Blackberries",
	Item.YELLOW_HONEY: "Honeycomb",
	Item.ORANGE_HONEY: "Orange Honey",
	Item.SUGAR_CANE: "Sugar Cane",
	Item.RED_JUICE: "Red Juice",
	Item.BERRY_JAM: "Berry Jam",
	Item.GRAPE_CORDIAL: "Grape Cordial",
	Item.FRUIT_PUNCH: "Fruit Punch",
	Item.BERRY_TONIC: "Berry Tonic",
}

## Icon texture for each item, used everywhere an item needs to be drawn
## (inventory slots, cauldron recipe chips, ...). The art style is flat
## block-colour, but items themselves are always shown as pictures, never
## as a plain colour swatch.
##
## RED_FRUIT/BLUE_FRUIT/PURPLE_FRUIT/PINK_BERRIES have real art, tightly
## cropped out of their (mostly transparent) source sprite. Every other
## item has no dedicated art yet, so it borrows the closest existing sprite
## as a placeholder:
##  - the brewed juice/jam/cordial reuse their source fruit's icon
##  - Fruit Punch and Berry Tonic (the two mixed brews you can actually
##    make) get their own distinct placeholders
##  - Blackberries/Honeycomb/Orange Honey/Sugar Cane have no forage source
##    or recipe yet, so which placeholder they get doesn't matter in play
var ITEM_ICON := {}

func _ready() -> void:
	ITEM_ICON = {
		Item.RED_FRUIT: _cropped("res://assets/FruitRed.png", Rect2(21, 29, 83, 62)),
		Item.BLUE_FRUIT: _cropped("res://assets/FruitBlue.png", Rect2(21, 29, 83, 63)),
		Item.PURPLE_FRUIT: _cropped("res://assets/FruitPurple.png", Rect2(20, 30, 83, 62)),
		Item.PINK_BERRIES: _cropped("res://assets/Berries.png", Rect2(24, 27, 90, 87)),

		Item.RED_JUICE: _cropped("res://assets/FruitRed.png", Rect2(21, 29, 83, 62)),
		Item.BERRY_JAM: _cropped("res://assets/Berries.png", Rect2(24, 27, 90, 87)),
		Item.GRAPE_CORDIAL: _cropped("res://assets/FruitPurple.png", Rect2(20, 30, 83, 62)),
		Item.FRUIT_PUNCH: preload("res://assets/Cauldron.png"),
		Item.BERRY_TONIC: preload("res://assets/BerryBush.png"),

		Item.BLACK_BERRIES: preload("res://assets/Bush.png"),
		Item.YELLOW_HONEY: preload("res://assets/TreeBerry.png"),
		Item.ORANGE_HONEY: preload("res://assets/TreeBerry2.png"),
		Item.SUGAR_CANE: preload("res://assets/TreeBerry3.png"),
	}

## Crops a tight, mostly-empty source sprite down to just the drawn pixels
## so it reads clearly at inventory-icon size, via a shared AtlasTexture
## (no new image files needed).
func _cropped(path: String, region: Rect2) -> Texture2D:
	var atlas := AtlasTexture.new()
	atlas.atlas = load(path)
	atlas.region = region
	return atlas

## Cauldron recipes. Each: input Item -> count, producing one output Item.
## The recipe is named after its output, so ITEM_NAME[output] is the label.
## Only ingredients that can actually be foraged in the overworld are used.
var RECIPES := [
	{"inputs": {Item.RED_FRUIT: 3}, "output": Item.RED_JUICE},
	{"inputs": {Item.PINK_BERRIES: 3}, "output": Item.BERRY_JAM},
	{"inputs": {Item.PURPLE_FRUIT: 3}, "output": Item.GRAPE_CORDIAL},
	{"inputs": {Item.RED_FRUIT: 1, Item.BLUE_FRUIT: 1, Item.PURPLE_FRUIT: 1}, "output": Item.FRUIT_PUNCH},
	{"inputs": {Item.PINK_BERRIES: 2, Item.BLUE_FRUIT: 1}, "output": Item.BERRY_TONIC},
]
