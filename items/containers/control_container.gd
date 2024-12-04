extends Control
## This is a simple version of a container. Opens when its container is clicked.

@export var inventory_menu: Control
@export var is_open: bool = false:
	set(value):
		is_open = value
		inventory_menu.visible = is_open

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			is_open = not is_open
