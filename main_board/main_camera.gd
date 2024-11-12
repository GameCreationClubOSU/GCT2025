class_name MainCamera
extends Camera2D
## Handles the camera on the main board. This includes the dragging.

# Will need some way later to tell exactly how big the window is
# and be able to focus accordingly.
# If focus, then mouse movements disabled.
var focus: Node2D

## Damping on the velocity of the camera. 
## Higher values means camera will slow down faster.
@export_range(0, 100) var damping: float = 10

## How fast the camera zooms in and out
@export_category("Zoom")
@export_range(0, 10) var zoom_speed: float = 5
@export_range(0, 1) var min_zoom: float = 0.5
@export_range(1, 10) var max_zoom: float = 2

var velocity: Vector2 = Vector2.ZERO
var dragging: bool = false
## Camera will try to keep global mouse position at this position.
## I.e. camera will move so that the cursor looks like it doesn't move relative
## to board. Set when user starts dragging.
var drag_start: Vector2 = Vector2.ZERO
## The value the zoom will approach over time.
var zoom_target: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if dragging:
		var mouse_current: Vector2 = get_global_mouse_position()
		
		# Good old displacement / time
		# Displacement usually current - previous, but we're moving the camera
		# backwards so that the mouse position doesn't change relative to world
		velocity = (drag_start - mouse_current) / delta
		position += (drag_start - mouse_current)
	else:
		position += velocity * delta
		velocity -= velocity.normalized() * velocity.length() * damping * delta
		
	# Zoom handling
	zoom = zoom.move_toward(Vector2(zoom_target, zoom_target), zoom.length() * zoom_speed * delta)
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true
				drag_start = get_global_mouse_position()
			elif event.is_released():
				dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_target *= 1.1
			zoom_target = clamp(zoom_target, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_target /= 1.1
			zoom_target = clamp(zoom_target, min_zoom, max_zoom)
			
