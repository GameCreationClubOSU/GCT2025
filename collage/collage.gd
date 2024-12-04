class_name Collage
extends Node2D
# The Collage handles everything that happens on the collage scene.

## The camera for the collage scene
@export var camera: CollageCamera
## The inventory menu for the Cooridinator inventory.
## The reason this is in here and not coordinator is because each minigame
## should be able to run in its own scene. This doesn't need to be accessible
## from those individual scenes.
@export var inventory_menu: GridInventoryMenu
@export var selection_slot: SelectionSlot

var focus: Miniframe: 
	set(value):
		if is_instance_valid(focus):
			focus.enabled = false
			
		focus = value
		camera.focus = value
		selection_slot.visible = not is_instance_valid(value)
		
		if is_instance_valid(focus):
			focus.enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Coordinator.miniframe_clicked.connect(func(miniframe): focus = miniframe)
	inventory_menu.bind_to_inventory(Coordinator.inventory)
	inventory_menu.visible = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_minigame"):
		focus = null
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("toggle_collage_inventory"):
		inventory_menu.visible = not inventory_menu.visible
		get_viewport().set_input_as_handled()
