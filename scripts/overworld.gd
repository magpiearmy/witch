extends Node

var forest_scene = preload("res://scenes/root_scenes/forest.tscn")
var cottage_scene = preload("res://scenes/root_scenes/cottage.tscn")

var current_scene: Node2D

@onready var witch = $Witch

func _ready() -> void:
	connect_signals()

func connect_signals():
	witch.connect("interact_with_body", on_witch_interaction)
	SignalBus.enter_cottage.connect(switch_overworld_scene.bind(cottage_scene))
	SignalBus.exit_cottage.connect(switch_overworld_scene.bind(forest_scene))

func on_witch_interaction(body: Node2D) -> void:
	print("Witch interacts with: " + str(body))
	if body.has_method("interact"):
		body.interact()
		return # only interact with first thing
	
func switch_overworld_scene(scene: PackedScene):
	print("Switching scene: " + str(scene))
	var new_scene = scene.instantiate()
	if current_scene:
		remove_child(current_scene)
	add_child(new_scene)
	witch.reparent(new_scene, false)
	witch.end_transition()
	witch.global_position = new_scene.get_node("StartPoint").global_position
	current_scene = new_scene
