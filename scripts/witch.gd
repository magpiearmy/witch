extends CharacterBody2D

signal interact_with_body(body)

const SELECTOR_LENGTH = 72
const MOVE_SPEED = 350
var current_speed = 0
var current_direction = Vector2.DOWN

var inventory = []

enum MoveState
{
	IDLE,
	MOVING,
	IN_TRANSITION,
	DISABLED
}
var move_state = MoveState.IDLE

func _process(_delta: float):
	if move_state not in [MoveState.IN_TRANSITION, MoveState.DISABLED]:
		var movement_vector = Input.get_vector("playerLeft", "playerRight", "playerUp", "playerDown")
		var run_modifier = 2 if Input.is_action_pressed("playerRun") else 1
		velocity = movement_vector * MOVE_SPEED * run_modifier
	
		if movement_vector != Vector2.ZERO and movement_vector != current_direction:
			set_direction(movement_vector)
			
		move_and_slide()
		
	
func _ready():
	set_direction(Vector2.RIGHT)
	
func _input(event):
	if move_state in [MoveState.IN_TRANSITION, MoveState.DISABLED]:
		return
	
	if event.is_action_pressed("interact"):
		interact()
		
func set_direction(direction: Vector2):
	current_direction = direction
	if direction.x > 0:
		$AnimatedSprite2D.frame = 0
		$Selector.target_position = Vector2(SELECTOR_LENGTH, 0)
	elif direction.x < 0:
		$AnimatedSprite2D.frame = 1
		$Selector.target_position = Vector2(-SELECTOR_LENGTH, 0)
	elif direction.y < 0:
		$AnimatedSprite2D.frame = 2
		$Selector.target_position = Vector2(0, -SELECTOR_LENGTH)
	elif direction.y > 0:
		$Selector.target_position = Vector2(0, SELECTOR_LENGTH)
		$AnimatedSprite2D.frame = 3


func interact():
	if $Selector.is_colliding(): 
		interact_with_body.emit($Selector.get_collider())
		

func transition(dest: Vector2, tween: Tween, zoom_in: bool):
	var target_zoom = Vector2(1.2, 1.2) if zoom_in else Vector2(1,1)
	tween.tween_property($Camera2D, "zoom", target_zoom, 1)
	tween.tween_property(self, "global_position", dest, 1)
	move_state = MoveState.IN_TRANSITION
	
func end_transition():
	move_state = MoveState.IDLE
	
func enable_movement():
	move_state = MoveState.IDLE
	
func disable_movement():
	move_state = MoveState.DISABLED
