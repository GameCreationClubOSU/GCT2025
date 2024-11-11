class_name DebugComponents
extends Object
## Library for debug menu components
## ImGui GDScript is quite annoying to use. 
## There's no multiple returns so you have to use an array for i/o

static func InputVector2(label: String, v: Array):
	var vector: Vector2 = v[0]
	var vector_arr = [vector.x, vector.y]
	var changed = ImGui.InputFloat2(label, vector_arr)
	v[0] = Vector2(vector_arr[0], vector_arr[1])
	return changed
