extends Node

enum FruitType {BLUE, PURPLE, RED}

enum Item {
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

## Flat block colour for each item, used by inventory swatches and cauldron chips.
var ITEM_COLOR := {
	Item.RED_FRUIT: Color("d9584f"),
	Item.BLUE_FRUIT: Color("5b8fd9"),
	Item.PURPLE_FRUIT: Color("9b5bd9"),
	Item.PINK_BERRIES: Color("e58cc4"),
	Item.BLACK_BERRIES: Color("3a2f4a"),
	Item.YELLOW_HONEY: Color("f2c94c"),
	Item.ORANGE_HONEY: Color("f2994a"),
	Item.SUGAR_CANE: Color("d9d3c2"),
	Item.RED_JUICE: Color("c0392b"),
	Item.BERRY_JAM: Color("c2185b"),
	Item.GRAPE_CORDIAL: Color("6c3483"),
	Item.FRUIT_PUNCH: Color("e67e22"),
	Item.BERRY_TONIC: Color("2e86ab"),
}

## Cauldron recipes. Each: input Item -> count, producing one output Item.
## Only ingredients that can actually be foraged in the overworld are used.
var RECIPES := [
	{"name": "Red Juice", "inputs": {Item.RED_FRUIT: 3}, "output": Item.RED_JUICE},
	{"name": "Berry Jam", "inputs": {Item.PINK_BERRIES: 3}, "output": Item.BERRY_JAM},
	{"name": "Grape Cordial", "inputs": {Item.PURPLE_FRUIT: 3}, "output": Item.GRAPE_CORDIAL},
	{"name": "Fruit Punch", "inputs": {Item.RED_FRUIT: 1, Item.BLUE_FRUIT: 1, Item.PURPLE_FRUIT: 1}, "output": Item.FRUIT_PUNCH},
	{"name": "Berry Tonic", "inputs": {Item.PINK_BERRIES: 2, Item.BLUE_FRUIT: 1}, "output": Item.BERRY_TONIC},
]
