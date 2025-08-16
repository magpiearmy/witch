extends Node2D
class_name Fruit

var type: Constants.FruitType

func set_type(type: Constants.FruitType):
	self.type = type
	match type:
		Constants.FruitType.RED:
			$Collectable.item_type = Constants.Item.RED_FRUIT
		Constants.FruitType.BLUE:
			$Collectable.item_type = Constants.Item.BLUE_FRUIT
		Constants.FruitType.PURPLE:
			$Collectable.item_type = Constants.Item.PURPLE_FRUIT
	
	$AnimatedSprite2D.frame = type
