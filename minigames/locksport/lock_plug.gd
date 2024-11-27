extends RigidBody2D

# If I cared, the dragging would be handled separately so as to not repeat myself
# across pick.gd and lock_plug.gd, but whatever. Can't be bothered.

var start_y: float
var mouse_start: Vector2 = Vector2.ZERO
var drag_vector: Vector2 = Vector2.ZERO
var dragging: bool = false
var drag_lock: bool = false
@onready var drag_display = $DragDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_y = global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	drag_display.visible = dragging or drag_lock
	if dragging:
		drag_vector = get_global_mouse_position() - mouse_start
		drag_display.points[1] = drag_display.points[0] + drag_vector
	
func _physics_process(_delta: float) -> void:
	if dragging or drag_lock:
		apply_central_force(drag_vector * 100)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Making sure the plug can only slide and not fall.
	linear_velocity = Vector2(state.linear_velocity.x, 0)
	global_position.y = start_y
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			drag_lock = false
			mouse_start = get_global_mouse_position();
			drag_display.visible = true
			drag_display.points[0] = get_local_mouse_position()
			dragging = true
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				dragging = false
		elif dragging and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				drag_lock = true
				dragging = false
		
