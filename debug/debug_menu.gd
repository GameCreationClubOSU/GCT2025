class_name DebugMenu
extends Node
## Responsible for handling all the deug menus.
## Seeks them out through the group system.

static var group_name = "debug_menu"

var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not enabled:
		return
		
	var nodes: Array[Node] = get_tree().get_nodes_in_group(group_name)
	var modules: Array[DebugModule] = []
	for node in nodes:
		if node is DebugModule:
			modules.append(node)
		
	for module in modules:
		# TODO: Check if module is even processing. Debug modules in disabled minigames should not be rendered.
		if module.enabled:
			module.render_debug()
			
	menu_list(modules)	

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug_menu")):
		enabled = not enabled
		
func menu_list(modules: Array[DebugModule]) -> void:
	if ImGui.Begin("Debug Menus"):
		for module in modules:
			enabled = [module.enabled]
			if ImGui.Checkbox(module.menu_name, enabled):
				module.enabled = enabled[0]
		ImGui.End()
