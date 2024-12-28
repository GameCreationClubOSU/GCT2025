extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		enabled = enabled_ref[0]
		
		ImGui.SeparatorText("Registered Minigames")
		for frame in Coordinator.miniframes:
			ImGui.Text(DebugUtil.node_name(frame))
		
		ImGui.End()
