extends RigidBody2D

func _on_button_body_entered(body: Node2D) -> void:
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
