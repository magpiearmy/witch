extends Control

var _satchel_open = false

func _ready():
	_connect_signals()

	
func _connect_signals():
	SignalBus.cauldron_opened.connect(_open_satchel)
	SignalBus.cauldron_closed.connect(_close_satchel)
	
func _open_satchel():
	_satchel_open = true
	$HUD.hide()
	$Satchel.show()
	$Dim.show()
	
func _close_satchel():
	_satchel_open = false
	$HUD.show()
	$Satchel.hide()
	$Dim.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if _satchel_open:
			_close_satchel()
		else:
			_open_satchel()
	
