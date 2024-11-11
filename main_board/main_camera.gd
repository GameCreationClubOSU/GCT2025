extends Camera2D
## Handles the camera on the main board. This includes the dragging.

# Will need some way later to tell exactly how big the window is
# and be able to focus accordingly.
# If focus, then mouse movements disabled.
var focus: Node2D 

## Damping on the velocity of the camera. 
## Higher values means camera will slow down faster.
@export_range(0, 100) var damping: float = 10
var velocity: Vector2 = Vector2.ZERO
var dragging: bool = false
## Camera will try to keep global mouse position at this position.
## I.e. camera will move so that the cursor looks like it doesn't move relative
## to board. Set when user starts dragging.
var drag_start: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if dragging:
		var mouse_current = get_global_mouse_position()
		
		# Good old displacement / time
		# Displacement usually current - previous, but we're moving the camera
		# backwards so that the mouse position doesn't change relative to world
		velocity = (drag_start - mouse_current) / delta
		position += (drag_start - mouse_current)
	else:
		position += velocity * delta
		
		velocity -= velocity.normalized() * velocity.length() * damping * delta
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true
				drag_start = get_global_mouse_position()
			if event.is_released():
				dragging = false
