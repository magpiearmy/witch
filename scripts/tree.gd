extends StaticBody2D

#var t1 = preload("res://Tree1.png")
#var t2 = preload("res://Tree2.png")
var fruit_scene = preload("res://scenes/fruit.tscn")

func _ready():
	var has_fruit = bool(randi() % 4)
	if has_fruit:
		$Fruit.set_type(Constants.FruitType.values().pick_random())
	else:
		remove_child($Fruit)

func interact():
	if $Fruit:
		$Fruit/Collectable.try_collect()
