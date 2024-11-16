extends Node2D
class_name gameInstance

var level_index : int = 1
var credits = "res://minigames/shadows_and_alchemy/Scenes/credits.tscn"
var level1 = "res://minigames/shadows_and_alchemy/Scenes/Level.tscn"
var level2 = "res://minigames/shadows_and_alchemy/Scenes/Level2.tscn"
var level3 = "res://minigames/shadows_and_alchemy/Scenes/Level3.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func load_current_level():
	match level_index:
		1:
			get_tree().change_scene_to_file(level1)
		2:
			get_tree().change_scene_to_file(level2)
		3:
			get_tree().change_scene_to_file(level3)
		_:
			get_tree().change_scene_to_file(credits)


func load_next_level():
	level_index += 1
	load_current_level()
