extends CharacterBody2D



const SPEED = 180.0
const JUMP_VELOCITY = -350.0
signal recall
signal star_move
signal star_attack
signal star_swap
var health = 3
var fallbackpos: Vector2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		fallbackpos = position

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk")
	elif Input.is_action_pressed("move_right"):
		velocity.x =  SPEED
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")
		
	if Input.is_action_pressed("star_return"):
		#move star to player
		recall.emit(position)
	if Input.is_action_pressed("move_star"):
		#move star to mouse
		star_move.emit(get_global_mouse_position())
		
	if Input.is_action_just_pressed("shoot_star"):
		star_attack.emit()
	
	if Input.is_action_just_pressed("swap_star"):
		star_swap.emit()

	if Input.is_action_pressed("jump"):
		pass #$AnimatedSprite2D.play("jump")

	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true

	elif Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false

	else:
		$AnimatedSprite2D.play("idle")
		
	move_and_slide()

func _on_fall_detector_body_entered(body: Node) -> void:
	health -= 1
	fallbackpos.x -= 75
	position = fallbackpos


func _on_camera_change_body_entered(body: Node2D) -> void:
	$Camera2D.zoom.x = 2
	$Camera2D.zoom.y = 2
	$Camera2D.offset.y = -100


func _on_camera_change_body_exited(body: Node2D) -> void:
	$Camera2D.zoom.x = 3
	$Camera2D.zoom.y = 3
	$Camera2D.offset.y = 0
