extends Node2D

var current_overworld_scene: Node2D

var forest_scene = preload("res://scenes/overworld_scenes/forest.tscn")
var cottage_scene = preload("res://scenes/overworld_scenes/cottage.tscn")

@onready var witch = $Overworld/Witch

func _ready() -> void:
	_connect_signals()
	_swap_overworld_scene(forest_scene)  # first load: no fade

func _connect_signals():
	witch.connect("interact_with_body", _on_witch_interaction)
	SignalBus.enter_cottage.connect(func(): _go_to(cottage_scene))
	SignalBus.exit_cottage.connect(func(): _go_to(forest_scene))
	SignalBus.on_collect_success.connect(_on_collect)
	SignalBus.on_collect_fail.connect(_on_collect_fail)
	SignalBus.cauldron.connect(_on_cauldron_interact)
	SignalBus.cauldron_closed.connect(_on_cauldron_closed)

func _on_collect(_item):
	$Sounds/AudioCollect.pitch_scale = 2
	$Sounds/AudioCollect.play()

func _on_collect_fail():
	$Sounds/AudioCollect.pitch_scale = 0.75
	$Sounds/AudioCollect.play()
	
func _on_cauldron_interact():
	$Overworld.process_mode = Node.PROCESS_MODE_DISABLED

func _on_cauldron_closed():
	$Overworld.process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_witch_interaction(body: Node2D) -> void:
	if body.has_method("interact"):
		body.interact()
		return # only interact with first thing
	
func _go_to(scene: PackedScene) -> void:
	SceneTransition.play(_swap_overworld_scene.bind(scene))

func _swap_overworld_scene(scene: PackedScene) -> void:
	var new_scene = scene.instantiate()
	$Overworld.add_child(new_scene)
	witch.reparent(new_scene, false)
	if current_overworld_scene:
		current_overworld_scene.queue_free()
	witch.global_position = new_scene.get_node("StartPoint").global_position
	current_overworld_scene = new_scene
