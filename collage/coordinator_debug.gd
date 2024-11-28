extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		enabled = enabled_ref[0]
		var parent: Node = get_parent()
		if parent is not Coordinator:
			ImGui.Text("Parent is not a Coordinator!")
			ImGui.End()
			return
		var coordinator: Coordinator = parent as Coordinator
		
		ImGui.Text("Focus: %s" % DebugUtil.node_name(coordinator.focus))
		 
		
		ImGui.End()
