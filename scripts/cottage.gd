extends Node2D

func _cottage_exit_transition(_body: Node2D) -> void:
	var tween = create_tween()
	tween.set_parallel()
	$Witch.transition($ExitTransitionEnd.global_position, tween, false)
	tween.tween_property($FadeOutCanvas/FadeOutRect, "modulate:a", 1, 1)
	get_tree().create_timer(1).timeout.connect(func(): SignalBus.exit_cottage.emit())
