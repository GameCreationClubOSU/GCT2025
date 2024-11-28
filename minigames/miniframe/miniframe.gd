@tool
class_name Miniframe
extends SubViewportContainer

signal clicked(miniframe: Miniframe)

## Scale of the scene inside the viewport.
## Adjusting the scale of the container has a similar effect, but this value won't distort the frame.
@export_range(0.01, 10) var viewport_scale: float = 1
## Scene that will be rendered inside the viewport.
@export var scene: PackedScene:
	set(value):
		# @export variables call the setter before viewport is loaded
		# Await ready to make sure that viewport isn't null.
		if not is_node_ready():
			await ready
		scene = value
		reload_scene()
@export var auto_reset: bool = true

## This reference is used for automatically resizing the frame and not for external use.
var _frame_rect: NinePatchRect = get_node_or_null("Frame") as NinePatchRect

@onready var viewport: SubViewport = $SubViewport

var enabled: bool = false:
	set(value):
		enabled = value
		viewport.process_mode = PROCESS_MODE_INHERIT if enabled else PROCESS_MODE_DISABLED
		# TODO: This should probably save the value first. Not every scene needs object picking.
		viewport.physics_object_picking = enabled
		
func adjust_frame() -> void:
	if not is_instance_valid(_frame_rect):
		_frame_rect = get_node_or_null("Frame") as NinePatchRect
	if not is_instance_valid(_frame_rect):
		# In case the get node call is null still.
		return
		
	# Automatically adjusting frame.
	_frame_rect.position = Vector2(-_frame_rect.patch_margin_left, -_frame_rect.patch_margin_top)
	_frame_rect.size = size + Vector2(_frame_rect.patch_margin_left + _frame_rect.patch_margin_right,
			_frame_rect.patch_margin_top + _frame_rect.patch_margin_bottom)
			
func adjust_viewport() -> void:
	viewport.size_2d_override = size * viewport_scale
	
func reload_scene() -> void:
	# Clear out all child nodes in viewport before adding more
	for child in viewport.get_children():
		viewport.remove_child(child)
		child.queue_free()
		
	if is_instance_valid(scene) and scene.can_instantiate():
		var new_child: Node = scene.instantiate()
		viewport.add_child(new_child)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		MinigameManager.register_miniframe(self)
		reload_scene()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	adjust_frame()
	adjust_viewport()

func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton:
		# Make sure the clicked signal only fires when the frame is not enabled.
		# Events need to pass down to the subviewport.
		if not enabled and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
			accept_event()
	elif auto_reset and enabled and event.is_action_pressed("reset"):
		reload_scene()
		get_viewport().set_input_as_handled()
			
