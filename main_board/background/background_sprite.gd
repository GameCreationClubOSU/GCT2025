extends Sprite2D
## Resizes the background sprite to always cover the camera.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	# Changing the height and width will regenerate the texture
	# so only do it if necessary.
	if width != texture.width:
		texture.width = width
	if height != texture.height: 
		texture.height = height
