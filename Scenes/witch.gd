extends CharacterBody2D

signal interact_with_body(body)

@export var max_speed = 300
var speed = max_speed
const SELECTOR_LENGTH = 72

var direction = Vector2.UP

func _process(_delta: float) -> void:
	direction = Input.get_vector("playerLeft", "playerRight", "playerUp", "playerDown")
	velocity = direction * speed
	move_and_slide()
		
	set_sprite_frame()
	
func _input(event):
	if event.is_action_pressed("interact"):
		interact()
	
func set_sprite_frame():
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
		$AnimatedSprite2D.frame = 3
		$Selector.target_position = Vector2(0, SELECTOR_LENGTH)


func interact():
	if $Selector.is_colliding():
		interact_with_body.emit($Selector.get_collider())
