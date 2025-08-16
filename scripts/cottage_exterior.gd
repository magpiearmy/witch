extends StaticBody2D

signal player_entered_cottage

func _on_player_entered(body: Node2D):
	player_entered_cottage.emit()
