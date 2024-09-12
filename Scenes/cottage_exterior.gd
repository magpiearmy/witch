extends StaticBody2D

signal player_entered_cottage

func _on_player_entered(body: Node2D):
	print('theres a witch up in this bitch')
	player_entered_cottage.emit()
