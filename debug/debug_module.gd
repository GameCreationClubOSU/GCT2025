class_name DebugModule 
extends Node
## Stores a debug module.

## The name that will be displayed on debug menus.
## This should be used in the ImGui.Begin call of the render_debug override.
@export var menu_name: String = ""
var enabled: bool = false

# If you override the ready method
# Add your node to the group manually or add this line in your ready method
# or call super()
func _ready() -> void:
	add_to_group(DebugMenu.group_name)

## This method will be called to render the debug window.
## Extending classes should override this.
func render_debug() -> void:
	pass
