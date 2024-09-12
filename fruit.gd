extends Node2D

enum FruitType {RED, BLUE, PURPLE}
@export var type: FruitType = FruitType.values()[randi()%3]
