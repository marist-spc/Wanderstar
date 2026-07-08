extends CharacterBody2D

#projectile launch
var health = 3
		#
#func _physics_process(delta: float): #Basic Goomba Code
	#
	#if direction == -1:
		#$AnimatedSprite2D.flip_h = false
		#$RayCast2D.position.x == $Body.shape.get_rect().size.x
	#else:
		#$AnimatedSprite2D.flip_h = true
		#$RayCast2D.position.x == $Body.shape.get_rect().size.x
	#$AnimatedSprite2D.play("walk")
	
@export var speed: float = 75.0

@onready var path_follow: PathFollow2D = get_parent()

func _process(_delta: float) -> void:
	global_rotation = 0.0
	
func _physics_process(delta: float) -> void:
	# Increase the mob's progress along the path by speed * time
	path_follow.progress += speed * delta
	$AnimatedSprite2D.rotation = 0

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 1
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$DamageTaken.start()
	if health == 0:
		queue_free()
	


func _on_damage_taken_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
