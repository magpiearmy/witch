extends Node2D

var current_overworld_scene: Node2D

var forest_scene = preload("res://scenes/overworld_scenes/forest.tscn")
var cottage_scene = preload("res://scenes/overworld_scenes/cottage.tscn")

@onready var witch = $Overworld/Witch

func _ready() -> void:
	_connect_signals()
	_switch_overworld_scene(forest_scene)

func _connect_signals():
	witch.connect("interact_with_body", _on_witch_interaction)
	SignalBus.enter_cottage.connect(_switch_overworld_scene.bind(cottage_scene))
	SignalBus.exit_cottage.connect(_switch_overworld_scene.bind(forest_scene))
	SignalBus.on_collect_success.connect(_on_collect)
	SignalBus.on_collect_fail.connect(_on_collect_fail)
	SignalBus.cauldron.connect(_on_cauldron_interact)

func _on_collect(_item):
	$Sounds/AudioCollect.pitch_scale = 2
	$Sounds/AudioCollect.play()

func _on_collect_fail():
	$Sounds/AudioCollect.pitch_scale = 0.75
	$Sounds/AudioCollect.play()
	
func _on_cauldron_interact():
	$Overworld.process_mode = Node.PROCESS_MODE_DISABLED
	
func _input(event: InputEvent):
	if event.is_action_pressed("cancel"):
		$Overworld.process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_witch_interaction(body: Node2D) -> void:
	if body.has_method("interact"):
		body.interact()
		return # only interact with first thing
	
func _switch_overworld_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	$Overworld.add_child(new_scene)
	witch.reparent(new_scene, false)
	if current_overworld_scene:
		$Overworld.remove_child(current_overworld_scene)
		current_overworld_scene.queue_free()
	witch.end_transition()
	witch.global_position = new_scene.get_node("StartPoint").global_position
	current_overworld_scene = new_scene
