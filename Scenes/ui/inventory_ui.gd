extends Control

var _is_open = false
var _forced_open = false

func _ready():
	_connect_signals()

	
func _connect_signals():
	SignalBus.cauldron_opened.connect(_open.bind(true))
	SignalBus.cauldron_closed.connect(_close)
	
func _open(force=false):
	_is_open = true
	_forced_open = force
	$HUD.hide()
	$Satchel.show()
	$Dim.show()
	
func _close():
	_is_open = false
	_forced_open = false
	$HUD.show()
	$Satchel.hide()
	$Dim.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory") and not _forced_open:
		if _is_open:
			_close()
		else:
			_open()
	
