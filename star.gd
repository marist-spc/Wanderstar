extends CharacterBody2D

var target_position = position

func _ready():
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide()
	$AnimatedSprite2D.play("idle")

func _on_wander_recall(pos):
	pos.x += 20
	position = pos
	target_position = pos
	$AnimatedSprite2D.play("teleport")
	
func _on_wander_star_move(pos):
	target_position = pos

func _physics_process(delta):
	#move the star to wherever its supposed to be going
	if target_position != position:
		var direction = (target_position - position).normalized()
		#controls direction and speed, log is used for smoothing
		velocity = direction * 50 * log(target_position.distance_to(position))
	#if close enough to target, stop moving
	if target_position.distance_to(position) < 3:
		velocity = position*0
		
		
func _process(delta):
	#makes the star follow mouse position
	if get_global_mouse_position().x >= position.x:
		$AnimatedSprite2D.flip_h = false
		look_at(get_global_mouse_position())
	elif get_global_mouse_position().x < position.x:
		$AnimatedSprite2D.flip_h = true
		#var
		look_at(get_global_mouse_position())
	
	#normal movement stuff
	position += velocity * delta
	move_and_slide()


func _on_wander_star_attack():
	#creates attack HB and starts a timer to recall the HB
	$Node2D/AttackHitbox.disabled = false
	$Node2D/AttackAnimation.show()
	$"Attack Timer".start()
	$AttackSound.play()


func _on_attack_timer_timeout():
	#after amt of time end the attack
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide()
