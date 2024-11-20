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

## Finds all the minigames in the scene and adds them to minigames array.
func find_minigames():
	var nodes: Array[Node] = get_tree().get_nodes_in_group("minigames")
	for node in nodes:
		if node is Minigame:
			var minigame := node as Minigame
			if minigame not in minigames:
				minigame.clicked.connect(minigame_clicked.emit)
				minigames.append(minigame)
		else:
			# Might be worth doing some duck typing here for more flexibility.
			# The lack of any interface in gdscript is annoying.
			push_warning("Node in minigames group is not a minigame object!")
			node.remove_from_group("minigames")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# May want to do this on some kind of schedule if 
	# we want to add minigames dynamically.
	# Or have some method here that allows minigames to register themselves.
	find_minigames()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
