extends CharacterBody2D

var target_position = position
var colors = ["yellow", "purple"]
var color_index = 0
var current_star = "yellow"
@export var wander: CharacterBody2D

func _ready():
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide()
	$SpriteController/YellowAnimations.play("idle")
	$SpriteController/PurpleAnimations.play("hide")



func _physics_process(delta):
	#move the star to wherever its supposed to be going
	
	if current_star == "purple":
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
	get_global_mouse_position()
	look_at(get_global_mouse_position())
	
	#normal movement stuff
	position += velocity * delta
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
	$Node2D/AttackHitbox.disabled = false
	$Node2D/AttackAnimation.show()
	$"Attack Timer".start()
	$AttackSound.play()


func _on_attack_timer_timeout():
	#after amt of time end the attack
	$Node2D/AttackHitbox.disabled = true
	$Node2D/AttackAnimation.hide() 


func _on_wander_star_swap() -> void:
	color_index += 1
	if color_index >= colors.size():
		color_index = 0
	current_star = colors[color_index]
	print(current_star)
	
	#Show the current star anim and hide the inactive ones
	if current_star == "yellow":
		$SpriteController/PurpleAnimations.visible = false
		$SpriteController/YellowAnimations.visible = true
		$SpriteController/YellowAnimations.play("idle")
	elif current_star == "purple":
		$SpriteController/PurpleAnimations.visible = true
		$SpriteController/YellowAnimations.visible = false
		$SpriteController/PurpleAnimations.play("idle")
