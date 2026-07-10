extends Area2D

var velocity:Vector2 = Vector2.ZERO

func _ready() -> void:
		$Explosion/ExplosionHitbox.disabled = true
		
func _physics_process(delta: float) -> void:
	#move_and_slide()
	position += velocity * delta
	
func _on_explode_control_body_entered(body: Node2D) -> void:
	$Explosion/ExplosionHitbox.set_deferred("disabled", false)
	$"Attack Timer".start()
	$AnimatedSprite2D.play("explode")
	$ExplosionSound.play()

func _on_attack_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		velocity = Vector2.ZERO
