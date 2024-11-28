extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		var parent: Node = get_parent()
		if parent is not CollageCamera:
			ImGui.Text("Parent is not a CollageCamera!")
			ImGui.End()
			return
		var camera: CollageCamera = parent as CollageCamera
		
		ImGui.SeparatorText("Basic")
		ImGui.Text("Focus: %s" % DebugUtil.node_name(camera.focus)) 

		ImGui.SeparatorText("Movement")
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
		
		var focus_damping: Array[Variant] = [camera.focus_damping]
		if ImGui.InputFloat("Focus Damping", focus_damping):
			camera.focus_damping = focus_damping[0]
		
		var move_speed: Array[Variant] = [camera.move_speed]
		if ImGui.InputFloat("Move Speed", move_speed):
			camera.move_speed = move_speed[0]
		
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
		
		var zoom_target: Array[Variant] = [camera.zoom_target]
		if ImGui.InputFloat("Zoom Target", zoom_target):
			camera.zoom_target = zoom_target[0]
		
		ImGui.SeparatorText("Drag")
		ImGui.Text("Dragging: %s" % camera.dragging)
		ImGui.Text("Drag Start: %.2v" % camera.drag_start)
		
		ImGui.End()
