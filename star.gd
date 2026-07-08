extends CharacterBody2D

var target_position = position
var colors = ["yellow", "purple"]
var color_index = 0
var current_star = "yellow"
var star_speed_modifier = 1
@export var wander: CharacterBody2D

func _ready():
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide()
	$SpriteController/YellowAnimations.play("idle")
	$SpriteController/PurpleAnimations.play("hide")
	$ExplodeControl/MovingHitbox.disabled = true
	$Explosion/ExplosionHitbox.disabled = true



func _physics_process(delta):
	#move the star to wherever its supposed to be going
	
	if current_star == "purple" && $"Attack Timer".time_left <= 0:
		target_position = wander.position
	
	if target_position != position:
		var direction = (target_position - position).normalized()
		#controls direction and speed, log is used for smoothing
		velocity = direction * 50 * log(target_position.distance_to(position))
	#if close enough to target, stop moving
	if target_position.distance_to(position) < 3:
		velocity = position*0
		
		
func _process(delta):
	#makes the star follow mouse position
	if $"Attack Timer".time_left <= 0:
		get_global_mouse_position()
		look_at(get_global_mouse_position())
	
	#normal movement stuff
	position += velocity * delta * star_speed_modifier
	move_and_slide()
	
	
func _on_wander_recall(pos):
	if current_star != "purple":
		pos.x += 20
		position = pos
		target_position = pos
		$SpriteController/YellowAnimations.play("teleport")
	
func _on_wander_star_move(pos):
	if current_star != "purple":
		target_position = pos
	


func _on_wander_star_attack():
	#creates attack HB and starts a timer to recall the HB
	if current_star == "yellow":
		$Node2D/AttackHitbox.disabled = false
		$Node2D/AttackAnimation.show()
		$"Attack Timer".start()
		$AttackSound.play()
	#launches star at cursor
	elif current_star == "purple":
		if $Node2D/RayCast2D.get_collider() != null:
			target_position = $Node2D/RayCast2D.get_collider().global_position
			star_speed_modifier = 2
			$"Attack Timer".start()
			$ExplodeControl/MovingHitbox.disabled = false
		


func _on_attack_timer_timeout():
	#after amt of time end the attack
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide() 
	star_speed_modifier = 1
	if current_star == "purple":
		position = wander.position
		$ExplodeControl/MovingHitbox.disabled = true
		$Explosion/ExplosionHitbox.disabled = true
		$SpriteController/PurpleAnimations.play("idle")


func _on_wander_star_swap() -> void:
	color_index += 1
	if color_index >= colors.size():
		color_index = 0
	current_star = colors[color_index]
	
	#Show the current star anim and hide the inactive ones
	if current_star == "yellow":
		$SpriteController/PurpleAnimations.visible = false
		$SpriteController/YellowAnimations.visible = true
		$SpriteController/YellowAnimations.play("idle")
	elif current_star == "purple":
		$SpriteController/PurpleAnimations.visible = true
		$SpriteController/YellowAnimations.visible = false
		$SpriteController/PurpleAnimations.play("idle")

#Collision check for the launched star
func _on_explode_control_body_entered(body: Node2D) -> void:
	$Explosion/ExplosionHitbox.set_deferred("disabled", false)
	$"Attack Timer".start()
	$SpriteController/PurpleAnimations.play("explode")
	target_position = position
