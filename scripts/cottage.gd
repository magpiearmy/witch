extends Node2D

var _transitioning := false

func _cottage_exit_transition(_body: Node2D) -> void:
	if _transitioning:
		return
	var witch := get_node_or_null("Witch")
	if witch == null:
		return
	_transitioning = true
	var tween = create_tween()
	tween.set_parallel()
	witch.transition($ExitTransitionEnd.global_position, tween, false)
	tween.tween_property($FadeOutCanvas/FadeOutRect, "modulate:a", 1, 1)
	get_tree().create_timer(1).timeout.connect(func(): SignalBus.exit_cottage.emit())
