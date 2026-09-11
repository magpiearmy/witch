extends Node2D
class_name Fruit

var type: Constants.FruitType

var type_to_item_map = {
	Constants.FruitType.RED: Constants.Item.RED_FRUIT,
	Constants.FruitType.BLUE: Constants.Item.BLUE_FRUIT,
	Constants.FruitType.PURPLE: Constants.Item.PURPLE_FRUIT
}

func set_type(type: Constants.FruitType):
	self.type = type
	$Collectable.item_type = type_to_item_map[type]	
	$AnimatedSprite2D.frame = type
