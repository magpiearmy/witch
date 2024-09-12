extends StaticBody2D

var t1 = preload("res://Tree1.png")
var t2 = preload("res://Tree2.png")

var has_fruit = randi() % 2

func _process(_delta):
	$Fruit.visible = has_fruit

func interact() -> void:
	if has_fruit:
		SignalBus.on_fruit_collected.emit()
		has_fruit = false
