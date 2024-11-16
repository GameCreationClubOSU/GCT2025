extends Area2D


func _on_body_entered(body):
	if body is Player:
		GameInstance.load_next_level()
	pass # Replace with function body.
