@tool
class_name Minigame
extends SubViewportContainer

signal clicked(minigame: Minigame)

## Scale of the scene inside the viewport.
## Adjusting the scale of the container has a similar effect, but this value won't distort the frame.
@export_range(0.01, 10) var viewport_scale: float = 1

## This reference is used for automatically resizing the frame and not for external use.
var _frame: NinePatchRect = get_node_or_null("Frame") as NinePatchRect

@onready var viewport: SubViewport = $SubViewport

var enabled: bool = false:
	set(value):
		enabled = value
		viewport.process_mode = PROCESS_MODE_INHERIT if enabled else PROCESS_MODE_DISABLED

func adjust_frame() -> void:
	if not is_instance_valid(_frame):
		_frame = get_node_or_null("Frame") as NinePatchRect
	if not is_instance_valid(_frame):
		# In case the get node call is null still.
		return
		
	# Automatically adjusting frame.
	_frame.position = Vector2(-_frame.patch_margin_left, -_frame.patch_margin_top)
	_frame.size = size + Vector2(_frame.patch_margin_left + _frame.patch_margin_right,
			_frame.patch_margin_top + _frame.patch_margin_bottom)
			
func adjust_viewport() -> void:
	viewport.size_2d_override = size * viewport_scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		MinigameManager.register_minigame(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	adjust_frame()
	adjust_viewport()

func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton:
		# Make sure the clicked signal only fires when the minigame is not enabled.
		# Events need to pass down to the subviewport.
		if not enabled and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
			get_viewport().set_input_as_handled()
