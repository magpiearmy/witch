extends CharacterBody2D

signal interact_with_body(body)

const SELECTOR_LENGTH = 72
const MOVE_SPEED = 350
var current_direction = Vector2.DOWN

func _process(_delta: float):
	var movement_vector = Input.get_vector("playerLeft", "playerRight", "playerUp", "playerDown")
	var run_modifier = 2 if Input.is_action_pressed("playerRun") else 1
	velocity = movement_vector * MOVE_SPEED * run_modifier

	if movement_vector != Vector2.ZERO and movement_vector != current_direction:
		set_direction(movement_vector)

	move_and_slide()

func _ready():
	set_direction(Vector2.RIGHT)

func _input(event):
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
