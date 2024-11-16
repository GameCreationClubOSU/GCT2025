extends Area2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.position = Vector2.ZERO
		body.velocity = Vector2.ZERO
	pass # Replace with function body.
