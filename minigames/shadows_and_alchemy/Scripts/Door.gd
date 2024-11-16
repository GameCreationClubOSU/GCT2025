extends StaticBody2D

var door_open_sprite = load("res://minigames/shadows_and_alchemy/Assets/Sprite Sheets/Door02.png")
var door_close_sprite = load("res://minigames/shadows_and_alchemy/Assets/Sprite Sheets/Door01.png")

func door_open():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.set_deferred("texture", door_open_sprite)
	
	pass
	
func door_close():
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite2D.set_deferred("texture", door_close_sprite)
	pass
