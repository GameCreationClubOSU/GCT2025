extends Node

## Gets movement input as a vector
## If invert_y is true, +y will point up towards the top of the screen, opposite what Godot normally has.
func movement_vector(invert_y: bool = true) -> Vector2:
	if invert_y:
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		return Input.get_vector("move_left", "move_right", "move_down", "move_up")
	
func horizontal_movement() -> float:
	return Input.get_axis("move_left", "move_right")
