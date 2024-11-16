extends Node2D

# The Coordinator is the top-level manager for the main board.
# Also stores the game state.

@export var camera: MainCamera

var focus: Minigame: 
	set(value):
		focus = value
		camera.focus = value

var minigames: Array[Minigame]

## Finds all the minigames in the scene.
func find_minigames() -> Array[Minigame]:
	var nodes = get_tree().get_nodes_in_group("minigames")
	var found_minigames: Array[Minigame]
	for node in nodes:
		if node is Minigame:
			found_minigames.append(node as Minigame)
		else:
			push_warning("Node in minigames group is not a minigame object!")
			node.remove_from_group("minigames")
	
	return found_minigames
	
func minigame_clicked(minigame: Minigame) -> void:
	focus = minigame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Don't know if we'll ever need to resync all the minigames
	# Perhaps some will be removed or spawn during runtime. 
	minigames.clear()
	for minigame in find_minigames():
		if not minigame.clicked.is_connected(minigame_clicked):
			minigame.clicked.connect(minigame_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				pass
				
