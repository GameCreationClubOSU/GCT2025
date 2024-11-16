extends Node2D

@onready var pause_menu : Control = $CharacterBody2D/PauseMenu
var paused : bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		#_pause_menu()
		pass

func _pause_menu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
