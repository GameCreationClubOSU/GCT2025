extends Node

## Emitted when a minigame was clicked. 
## Provides the miniframe object around the minigame that was clicked.
signal miniframe_clicked(miniframe: Miniframe)

var miniframes: Array[Miniframe] = []:
	set(value):
		push_error("Attempted to set value of miniframes field in MinigameManager directly!")

func in_collage() -> bool:
	var main_node = get_node_or_null("/root/Collage")
	return is_instance_valid(main_node) and main_node is Coordinator

## Gets the local minigame root for the node given.
## For consistency with the rest of Godot, the "root" is the node right above 
## the root node of scene. 
## For most nodes, proper usage is [code]MinigameManager.get_root_of(self)[/code]
## Returns the global root if running from outside the collage scene.
func get_root_of(node: Node) -> Node:
	# This is to allow games to run in their own independent scenes for testing.
	if in_collage():
		return get_tree().root
	
	# Normal case	
	for miniframe in miniframes:
		if miniframe.is_ancestor_of(node):
			return miniframe.viewport
			
	push_error("get_root_of has been called from a node that isn't in a minigame!")
	return null

## Registers a miniframe to the manager.
func register_miniframe(miniframe: Miniframe) -> void:
	if not is_instance_valid(miniframe):
		push_warning("Attempted to register invalid instance to Minigame manager!")
		return
	if miniframe in miniframes:
		push_warning("Attempted to register miniframe [%s] that was already registered!" % miniframe.name)
		return
		
	miniframe.enabled = false # Don't want minigames running until they're focused.
	miniframe.clicked.connect(miniframe_clicked.emit)
	miniframes.append(miniframe)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Clean up any minigames that have become invalid.
	for miniframe in miniframes:
		if not is_instance_valid(miniframe):
			miniframes.erase(miniframe)
