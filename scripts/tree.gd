extends StaticBody2D

var fruit_type = Constants.FruitType.values().pick_random()
@onready var fruit_template = $Fruit.duplicate()

func _ready():
	_connect_signals()
	_init_fruit()
	
func _connect_signals():
	SignalBus.on_collect_success.connect(self._check_fruit_collected)
	$AnimatedSprite.animation_finished.connect(func(): $AnimatedSprite.frame=0)
	
func _init_fruit():
	if randi() % 10 != 0:
		remove_child($Fruit)
		$Timer.start()
	else:
		$Fruit.set_type(fruit_type)
	
func interact():
	if $Fruit:
		$Fruit/Collectable.try_collect()
	
func _check_fruit_collected(item):
	if item == $Fruit:
		$AnimatedSprite.play()
		$Timer.start()
		
func _bear_fruit():
	var new_fruit = self.fruit_template.duplicate()
	new_fruit.set_type(fruit_type)
	add_child(new_fruit)

func _on_timer_timeout() -> void:
	if randi() % 10 == 0:
		_bear_fruit()
	else:
		$Timer.start()
