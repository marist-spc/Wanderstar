extends CharacterBody2D

var target_position = position

func _ready():
	$Node2D/AttackHitbox.disabled = true

func _on_wander_recall(pos):
	target_position = pos
	
func _on_wander_star_move(pos):
	target_position = pos

func _physics_process(delta):
	#move the star to wherever its supposed to be going
	if target_position != position:
		position = position.move_toward(target_position, 1000*delta)
	# difference of target_pos and pos is the vector pointing to where star should go
	# this can be the velocity
	# then use move_and_slide to actually move star with collision-0detection
func _process(delta):
	look_at(get_global_mouse_position())


func _on_wander_star_attack():
	$Node2D/AttackHitbox.disabled = false
	$"Attack Timer".start()


func _on_attack_timer_timeout():
	$Node2D/AttackHitbox.disabled = true
