extends Node2D

var _transitioning := false

func cottage_enter_transition():
	if _transitioning:
		return
	var witch := get_node_or_null("Witch")
	if witch == null:
		return
	_transitioning = true
	var tween = create_tween()
	tween.set_parallel()
	witch.transition($CottageExterior/EntryTransitionEnd.global_position, tween, true)
	tween.tween_property($FadeOutCanvas/FadeOutRect, "modulate:a", 1, 1)
	get_tree().create_timer(1).timeout.connect(func(): SignalBus.enter_cottage.emit())
