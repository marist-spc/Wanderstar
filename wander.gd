extends CharacterBody2D
const SPEED = 180.0
const JUMP_VELOCITY = -350.0
signal recall
signal star_move
signal star_attack
signal star_swap
signal player_death
signal new_game
var health = 3
var fallbackpos: Vector2
var input_enabled = true

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	$Camera2D/GameOverHud/Button.visible = false
	$Camera2D/GameOverHud/Label.visible = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		fallbackpos = position
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && input_enabled:
		velocity.y = JUMP_VELOCITY

		$AnimatedSprite2D.play("jump")


	# Get the input direcion and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("move_left") && input_enabled:
		velocity.x = -SPEED
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_right") && input_enabled:
		velocity.x =  SPEED
		$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_pressed("star_return") && input_enabled:
		#move star to player
		recall.emit(position)
	if Input.is_action_pressed("move_star") && input_enabled:
		#move star to mouse
		star_move.emit(get_global_mouse_position())
		
	if Input.is_action_just_pressed("shoot_star") && input_enabled:
		star_attack.emit()
	
	if Input.is_action_just_pressed("swap_star") && input_enabled:
		star_swap.emit()

	if Input.is_action_pressed("move_left")&& input_enabled:
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true

	elif Input.is_action_pressed("move_right") && input_enabled:
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
	
	elif is_on_floor():
		$AnimatedSprite2D.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump")
	
	move_and_slide()

func _on_fall_detector_body_entered(body: Node) -> void:
	fallbackpos.x -= 75
	position = fallbackpos
	damage_taken()

func _on_camera_change_body_entered(body: Node2D) -> void:
	$Camera2D.zoom.x = 2
	$Camera2D.zoom.y = 2
	$Camera2D.offset.y = -100

func _on_camera_change_body_exited(body: Node2D) -> void:
	$Camera2D.zoom.x = 3
	$Camera2D.zoom.y = 3
	$Camera2D.offset.y = 0

func _on_damage_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func _on_dialogue_trigger_body_entered(body: Node2D) -> void:
	$Camera2D/Dialogue.text = "WASD moves and Spacebar Jumps!"
	$Camera2D/Dialogue.show()

func _on_dialogue_trigger_body_exited(body: Node2D) -> void:
	$Camera2D/Dialogue.hide()

func _on_dialogue_trigger_2_body_entered(body: Node2D) -> void:
	$Camera2D/Dialogue.text = "Hold Right Click to Move Star
	and left click to attack Enemies!"
	$Camera2D/Dialogue.show()

func _on_dialogue_trigger_2_body_exited(body: Node2D) -> void:
	$Camera2D/Dialogue.hide()

func _on_dialogue_trigger_3_body_entered(body: Node2D) -> void:
	$Camera2D/Dialogue.text = "Monoliths appear when there is a puzzle to be solved!"
	$Camera2D/Dialogue.show()

func _on_dialogue_trigger_3_body_exited(body: Node2D) -> void:
	$Camera2D/Dialogue.hide()


func _on_dialogue_trigger_4_body_entered(body: Node2D) -> void:
	$Camera2D/Dialogue.text = "Press Q to Call Star Back!"
	$Camera2D/Dialogue.show()

func _on_dialogue_trigger_4_body_exited(body: Node2D) -> void:
	$Camera2D/Dialogue.hide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	damage_taken()
	
func damage_taken():
	health -= 1
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$DamageTimer.start()
	if health == 0:
		#queue_free()
		$Camera2D/GameOverHud/Button.visible = true
		$Camera2D/GameOverHud/Label.visible = true
		input_enabled = false
		player_death.emit()
		position = Vector2(183, 394)



func _on_button_pressed() -> void:
	new_game.emit()
	input_enabled = true
	$Camera2D/GameOverHud/Button.visible = false
	$Camera2D/GameOverHud/Label.visible = false
	
