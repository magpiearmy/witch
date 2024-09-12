extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_berry_collected.connect(collect_berry)
	SignalBus.on_fruit_collected.connect(collect_fruit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_cottage_transition():
	print('transitioning to cottage interior')
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($Witch, "speed", 0, 0.5)
	tween.tween_property($FadeOutCanvas/FadeOutRect, "modulate:a", 1, 1)
	get_tree().create_timer(1).timeout.connect(change_scene_to_interior)
	
func change_scene_to_interior():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")


func _on_witch_interaction(body: Variant) -> void:
	print("Witch interacts with: " + str(body))
	if body.has_method("interact"):
		body.interact()
	
func collect_berry():
	$AudioCollect.play()
	print("Collected berry!")
	
func collect_fruit():
	$AudioCollect.play()
	print("Collected fruit!")
