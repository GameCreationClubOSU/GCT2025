extends Area2D

@export var door_position : Vector2 = Vector2(100,0)
var button_up = load("res://minigames/shadows_and_alchemy/Assets/Sprite Sheets/Button01.png")
var button_down = load("res://minigames/shadows_and_alchemy/Assets/Sprite Sheets/Button02.png")
func _on_body_entered(body):
	if body is CharacterBody2D or body is RigidBody2D:
		$Door.door_open()
		$Sprite2D.set_deferred("texture", button_down)
	pass # Replace with function body.
	

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		$Door.door_close()
		$Sprite2D.set_deferred("texture", button_up)
	pass # Replace with function body.
