extends CanvasLayer
## Autoload. Owns a full-screen fade overlay and runs "fade out -> swap -> fade in"
## as a single awaitable sequence. Lives on the root, so it survives scene swaps.

signal midpoint  ## fired while the screen is fully covered, after the swap runs

var fade_duration := 0.6

var _rect: ColorRect
var _busy := false

func _ready() -> void:
	layer = 128                                # above everything
	process_mode = Node.PROCESS_MODE_ALWAYS    # keep animating while the tree is paused
	_rect = ColorRect.new()
	_rect.color = Color.BLACK
	_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.modulate.a = 0.0
	_rect.visible = false
	add_child(_rect)

## Fade to black, run `swap` at full black, fade back in.
## No-op if a transition is already running (guards against double triggers).
func play(swap: Callable) -> void:
	if _busy:
		return
	_busy = true
	get_tree().paused = true

	_rect.visible = true
	await _fade_to(1.0)

	swap.call()
	midpoint.emit()
	await get_tree().process_frame            # let the new scene enter the tree

	await _fade_to(0.0)
	_rect.visible = false
	get_tree().paused = false
	_busy = false

func _fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_rect, "modulate:a", alpha, fade_duration)
	await tween.finished
