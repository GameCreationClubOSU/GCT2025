extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		enabled = enabled_ref[0]
		var parent: Node = get_parent()
		if parent is not Collage:
			ImGui.Text("Parent is not a Collage instance!")
			ImGui.End()
			return
		var coordinator: Collage = parent as Collage
		
		ImGui.Text("Focus: %s" % DebugUtil.node_name(coordinator.focus))
		 
		
		ImGui.End()
