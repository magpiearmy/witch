extends Node2D

func _on_cottage_entered() -> void:
	SignalBus.cottage_entered.emit()
