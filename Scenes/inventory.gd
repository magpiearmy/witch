extends Control

var total_fruit = 0
var total_berries = 0

func _ready():
	SignalBus.on_fruit_collected.connect(_on_fruit_collected)
	SignalBus.on_berry_collected.connect(_on_berry_collected)

func _on_fruit_collected():
	total_fruit += 1
	$MarginContainer/VBoxContainer/HBoxContainer2/LabelFruitTotal.text = str(total_fruit)
	
func _on_berry_collected():
	total_berries += 1
	$MarginContainer/VBoxContainer/HBoxContainer/LabelBerriesTotal.text = str(total_berries)
