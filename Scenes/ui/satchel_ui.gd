extends Control
## The full satchel grid, docked to the right edge.
## Toggled with the "inventory" action anywhere in the overworld, and forced
## open (undimmed, above the cauldron's backdrop) while the cauldron is open.

@onready var _grid: GridContainer = $Panel/Margin/VBox/Grid
@onready var _hint: Label = $Panel/Margin/VBox/Hint

var _slots: Array = []
var _pinned := false   # player pressed the "inventory" key
var _forced := false   # cauldron panel is open

func _ready() -> void:
	var slot_scene := preload("res://scenes/ui/inventory_slot.tscn")
	for i in Inventory.CAPACITY:
		var slot := slot_scene.instantiate()
		_grid.add_child(slot)
		_slots.append(slot)
	_connect_signals()
	_refresh()
	_apply_visibility()
	
func _connect_signals():
	Inventory.changed.connect(_refresh)
	SignalBus.cauldron_opened.connect(_on_cauldron_opened)
	SignalBus.cauldron_closed.connect(_on_cauldron_closed)	

#func _unhandled_input(event: InputEvent) -> void:
	## While the cauldron holds the panel open the keybind does nothing, rather
	## than silently flipping a state you only see once you walk away.
	#if _forced:
		#return
	#if event.is_action_pressed("inventory"):
		#_pinned = not _pinned
		#_apply_visibility()
		#get_viewport().set_input_as_handled()
	#elif _pinned and event.is_action_pressed("cancel"):
		#_pinned = false
		#_apply_visibility()
		#get_viewport().set_input_as_handled()

func _on_cauldron_opened() -> void:
	_forced = true
	_apply_visibility()

func _on_cauldron_closed() -> void:
	_forced = false
	_apply_visibility()

func _apply_visibility() -> void:
	visible = _pinned or _forced
	_hint.visible = not _forced  # the cauldron panel owns the "leave" prompt then

func _refresh() -> void:
	Inventory.render_into(_slots)
