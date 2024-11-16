extends Sprite2D

@export var character_ref : Node2D
var line_points_number : float = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	

	pass

func get_aim_line_coordinates() -> PackedVector2Array:
	var target_position : Vector2 = position
	var character_pos : Vector2 = character_ref.position
	var aim_line_coordinates : PackedVector2Array
	
	var x_seperation = abs(target_position.x - character_pos.x)
	for index in line_points_number:
		
		pass
	
	return aim_line_coordinates

func _draw():
	pass
