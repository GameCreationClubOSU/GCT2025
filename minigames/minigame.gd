@tool
class_name Minigame
extends SubViewportContainer

signal clicked(minigame: Minigame)
@onready var viewport: SubViewport = $SubViewport
var enabled: bool = false:
	set(value):
		enabled = value
		viewport.process_mode = PROCESS_MODE_INHERIT if enabled else PROCESS_MODE_DISABLED

func adjust_frame() -> void:
	var frame = $Frame as NinePatchRect
	if not is_instance_valid(frame):
		push_error("Minigame has no frame child!")
		return
		
	frame.position = Vector2(-frame.patch_margin_left, -frame.patch_margin_top)
	frame.size = size + Vector2(frame.patch_margin_left + frame.patch_margin_right,
			frame.patch_margin_top + frame.patch_margin_bottom)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("minigames")
	enabled = false # Minigames off by default. 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		adjust_frame()

func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
