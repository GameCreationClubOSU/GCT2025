class_name Coordinator
extends Node2D

# The Coordinator is the top-level manager for the main board.
# Also stores the game state.

@export var camera: CollageCamera

var focus: Miniframe: 
	set(value):
		if is_instance_valid(focus):
			focus.enabled = false
			
		focus = value
		camera.focus = value
		
		if is_instance_valid(focus):
			focus.enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MinigameManager.miniframe_clicked.connect(func(miniframe): focus = miniframe)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_minigame"):
		focus = null	
				
