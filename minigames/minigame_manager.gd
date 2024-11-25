extends Node

## Emitted when a minigame was clicked. Provides the minigame object that was clicked.
signal minigame_clicked(minigame)

var minigames: Array[Minigame] = []:
	set(value):
		push_error("Attempted to set value of minigames field in MinigameManager directly!")

## Gets the local minigame root for the node given.
## For mode nodes, proper usage is [code]MinigameManager.get_root(self)[/code]
## The root is the viewport node just above all the other content nodes.
## Returns null if node is not in a minigame.
func get_root_of(node: Node) -> SubViewport:
	for minigame in minigames:
		if minigame.is_ancestor_of(node):
			return minigame.viewport
			
	return null

## Registers a minigame to the manager.
func register_minigame(minigame: Minigame) -> void:
	if not is_instance_valid(minigame):
		push_warning("Attempted to register invalid instance to Minigame manager!")
		return
	if minigame in minigames:
		push_warning("Attempted to register minigame [%s] that was already registered!" % minigame.name)
		return
		
	minigame.enabled = false
	minigame.clicked.connect(minigame_clicked.emit)
	minigames.append(minigame)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
