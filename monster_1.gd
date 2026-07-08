extends CharacterBody2D

@export var direction = -1
var health = 3
		
func _physics_process(delta: float): #Basic Goomba Code
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = false
		$RayCast2D.position.x == $Body.shape.get_rect().size.x
	else:
		$AnimatedSprite2D.flip_h = true
		$RayCast2D.position.x == $Body.shape.get_rect().size.x
	$AnimatedSprite2D.play("walk")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if $RayCast2D.is_colliding() == false:
		direction = -1 if direction == 1 else 1
		$RayCast2D.position.x *= -1
	if direction == 1:
		velocity.x = 40
		
	elif direction == -1:
		velocity.x = -40
		
	move_and_slide()


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 1
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$DamageTaken.start()
	if health == 0:
		queue_free()
	


func _on_damage_taken_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
