extends Area2D

func _ready():
	$AnimatedSprite2D.play("Inactive")
	
func _on_body_entered(body: Node2D):
	$AnimatedSprite2D.play("Active")
