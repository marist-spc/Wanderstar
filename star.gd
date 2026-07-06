extends CharacterBody2D

var target_position = position

func _ready():
	$Node2D/AttackHitbox.disabled = true

func _on_wander_recall(pos):
	position = pos
	target_position = pos
	
func _on_wander_star_move(pos):
	target_position = pos

func _physics_process(delta):
	#move the star to wherever its supposed to be going
	if target_position != position:
		var direction = (target_position - position).normalized()
		#controls direction and speed, log is used for smoothing
		velocity = direction * 50 * log(target_position.distance_to(position))
	if target_position.distance_to(position) < 3:
		velocity = position*0
		
		
func _process(delta):
	look_at(get_global_mouse_position())
	position += velocity * delta
	
	move_and_slide()


func _on_wander_star_attack():
	$Node2D/AttackHitbox.disabled = false
	$"Attack Timer".start()


func _on_attack_timer_timeout():
	$Node2D/AttackHitbox.disabled = true
