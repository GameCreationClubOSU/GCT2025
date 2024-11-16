class_name MainCamera
extends Camera2D
## Handles the camera on the main board. This includes the dragging.

var focus: Minigame:
	set(value):
		focus = value
		dragging = false

## Damping on the velocity of the camera. 
## Higher values means camera will slow down faster.
@export_range(0, 100) var damping: float = 10
@export_range(0, 100) var focus_damping: float = 10

## How fast the camera zooms in and out
@export_category("Zoom")
@export_range(0, 10) var zoom_speed: float = 5
@export_range(0, 1) var min_zoom: float = 0.5
@export_range(1, 10) var max_zoom: float = 2
@export_range(0.5, 2.0) var focus_zoom_multiplier: float = 1

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

func handle_drag(delta: float) -> void:
	if dragging:
		var mouse_current: Vector2 = get_global_mouse_position()
		
		# Good old displacement / time
		# Displacement usually current - previous, but we're moving the camera
		# backwards so that the mouse position doesn't change relative to world
		velocity = (drag_start - mouse_current) / delta
	else:
		velocity -= velocity.normalized() * velocity.length() * damping * delta
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(focus):
		var focus_center: Vector2 = focus.global_position + focus.size / 2
		velocity = (focus_center - global_position) / delta / focus_damping

		# Handling zoom
		var z: Vector2 = get_viewport_rect().size / focus.size
		zoom_target = min(z.x, z.y) * focus_zoom_multiplier
	else:
		handle_drag(delta)

	position += velocity * delta
	
	# Zoom handling
	zoom = zoom.move_toward(Vector2(zoom_target, zoom_target), zoom.length() * zoom_speed * delta)
		

func _unhandled_input(event: InputEvent) -> void:
	# Main board camera should _not_ move while focused on a minigame
	# We don't want the camera to start wandering away while player is playing.
	if is_instance_valid(focus):
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true
				drag_start = get_global_mouse_position()
			elif event.is_released():
				dragging = false
			
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_target *= 1.1
			zoom_target = clamp(zoom_target, min_zoom, max_zoom)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_target /= 1.1
			zoom_target = clamp(zoom_target, min_zoom, max_zoom)
			get_viewport().set_input_as_handled()
			
