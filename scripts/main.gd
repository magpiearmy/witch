extends Node2D

@onready var witch = $Overworld/Witch

func _ready() -> void:
	$Overworld.switch_overworld_scene($Overworld.forest_scene)
	SignalBus.on_collect_success.connect(on_collect)
	SignalBus.on_collect_fail.connect(on_collect_fail)
	SignalBus.cauldron.connect(on_cauldron_interact)

func on_collect():
	$Sounds/AudioCollect.pitch_scale = 1.5
	$Sounds/AudioCollect.play()

func on_collect_fail():
	$Sounds/AudioCollect.pitch_scale = 0.75
	$Sounds/AudioCollect.play()
	
func on_cauldron_interact():
	witch.disable_movement()
