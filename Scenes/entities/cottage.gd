extends Node2D

func _on_door_body_entered(_body: Node2D) -> void:
	SignalBus.cottage_exited.emit()
