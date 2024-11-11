extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		var camera = get_parent()
		
		enabled = enabled_ref[0]
		var world_position = [camera.global_position]
		if DebugComponents.InputVector2("World Position", world_position):
			camera.global_position = world_position[0]
		var velocity = [camera.velocity]
		if DebugComponents.InputVector2("Velocity", velocity):
			camera.velocity = velocity[0]
		var damping = [camera.damping]
		if ImGui.InputFloat("Damping", damping):
			camera.damping = damping[0]
		ImGui.End()
