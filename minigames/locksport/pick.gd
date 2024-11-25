extends RigidBody2D

# Local vector of where the player initially selected.
var mouse_start: Vector2 = Vector2.ZERO
# Local vector of the direction pulling.
var drag_vector: Vector2 = Vector2.ZERO

# Active left-click dragging
var dragging: bool = false
# Right-click lock that locks the drag vector in place
var drag_lock: bool = false
@onready var drag_display = $DragDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	drag_display.visible = dragging or drag_lock
	# Only change the drag vector if the player is actively dragging
	if dragging:
		drag_vector = get_local_mouse_position() - mouse_start;
		drag_display.points[1] = drag_display.points[0] + drag_vector
		
func _physics_process(_delta: float) -> void:
	if dragging or drag_lock:
		# transform * x - position transform the vector to a global one.
		# drag vector - position because that indication direction not position.
		# mouse_start - position because apply_force uses a global orientation but a local offset
		apply_force((transform * drag_vector - position) * 200, transform * mouse_start - position)
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			drag_lock = false
			mouse_start = get_local_mouse_position();
			drag_display.visible = true
			drag_display.points[0] = mouse_start
			dragging = true
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				dragging = false
		elif dragging and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				drag_lock = true
				dragging = false
		
