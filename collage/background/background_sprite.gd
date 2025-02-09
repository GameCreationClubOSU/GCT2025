@tool
extends Sprite2D
## Moves the sprite to always be visible in the editor.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset the position at runtime otherwise the background sprite can be 
	# outside the visible rect of the game camera.
	position = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# This code can only run in the editor
	# It doesn't need to run during runtime anyway, this sprite should be a 
	# child of the camera an centered regardless.
	if Engine.is_editor_hint():
		var camera_transform := EditorInterface.get_editor_viewport_2d().global_canvas_transform
		var canvas_item = get_canvas_item()
		RenderingServer.canvas_item_set_transform(canvas_item, camera_transform.affine_inverse())
		
