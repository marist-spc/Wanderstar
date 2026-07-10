extends CharacterBody2D

signal boss_dead

#projectile launch
var health = 15
	
@export var speed: float = 75.0

@onready var path_follow: PathFollow2D = get_parent()

@export var projectile_scene: PackedScene

func ready():
	$AnimatedSprite2D.play("float")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$ProjectileTimer.start

func _process(_delta: float) -> void:
	global_rotation = 0.0
	
func _physics_process(delta: float) -> void:
	# Increase the knight's progress along the path by speed * time
	path_follow.progress += speed * delta

func _on_projectile_timer_timeout():
	# Create a new instance of the Mob scene.
	var projectile = projectile_scene.instantiate()

	# Choose a random location on Path2D.
	var projectile_spawn_location = $ProjectileSpawn

	# Set the mob's position to the random location.
	projectile.position = projectile_spawn_location.position
	# Choose the velocity for the mob.
	projectile.velocity = Vector2(randf_range(-150.0, 150.0), randf_range(150.0, 250.0))

	# Spawn the mob by adding it to the Main scene.
	add_child(projectile)
	
#func _on_mob_timer_timeout(): #Spawns Projectiles
	#var mob = projectile_scene.instantiate()
	## Choose a random location on the SpawnPath.
	## We store the reference to the SpawnLocation node.
	#var mob_spawn_location = Woodknight
	## And give it a random offset.
	#mob_spawn_location.progress_ratio = randf()
#
	#var player_position = $Player.position
	#
	#mob.initialize(mob_spawn_location.position, player_position)
	## Spawn the mob by adding it to the Main scene.
	#add_child(mob)
	## We connect the mob to the score label to update the score upon squashing one.

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 1
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$DamageTaken.start()
	if health == 0:
		queue_free()
		boss_dead.emit()
		
	
func _on_damage_taken_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
