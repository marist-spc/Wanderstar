extends CharacterBody2D


func _ready() -> void:
		$Explosion/ExplosionHitbox.disabled = true
		velocity.x = randi_range(-60, 60)
		velocity.y = 40
		#velocity = Vector2.ZERO
		
func _physics_process(delta: float) -> void:
	
	position += velocity * delta
	move_and_slide()
	
func _on_explode_control_body_entered(body: Node2D) -> void:
	$Explosion/ExplosionHitbox.set_deferred("disabled", false)
	#$Explosion/ExplosionHitbox.disabledd = false
	$"Attack Timer".start()
	$AnimatedSprite2D.play("explode")
	$ExplosionSound.play()

func _on_attack_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		velocity = Vector2.ZERO
