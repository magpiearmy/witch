extends Node2D

func cottage_enter_transition():
	var tween = create_tween()
	tween.set_parallel()
	$Witch.transition($CottageExterior/EntryTransitionEnd.global_position, tween, true)
	tween.tween_property($FadeOutCanvas/FadeOutRect, "modulate:a", 1, 1)
	get_tree().create_timer(1).timeout.connect(func(): SignalBus.enter_cottage.emit())
