extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		var camera: Node = get_parent()
		
		enabled = enabled_ref[0]
		var world_position: Array[Variant] = [camera.global_position]
		if DebugComponents.InputVector2("World Position", world_position):
			camera.global_position = world_position[0]
		var velocity: Array[Variant] = [camera.velocity]
		if DebugComponents.InputVector2("Velocity", velocity):
			camera.velocity = velocity[0]
		var damping: Array[Variant] = [camera.damping]
		if ImGui.InputFloat("Damping", damping):
			camera.damping = damping[0]
		
		ImGui.SeparatorText("Zoom")
		var zoom_speed: Array[Variant] = [camera.zoom_speed]
		if ImGui.InputFloat("Zoom Speed", zoom_speed):
			camera.zoom_speed = zoom_speed[0]
		var min_zoom: Array[Variant] = [camera.min_zoom]
		if ImGui.InputFloat("Min Zoom", min_zoom):
			camera.min_zoom = min_zoom[0]
		var max_zoom: Array[Variant] = [camera.max_zoom]
		if ImGui.InputFloat("Max Zoom", max_zoom):
			camera.max_zoom = max_zoom[0]
		
		ImGui.End()
