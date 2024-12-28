extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		enabled = enabled_ref[0]
		
		ImGui.Text("In Collage: %s" % Coordinator.in_collage())
		DebugComponents.Inventory("Collage Inventory", Coordinator.inventory)
		
		ImGui.SeparatorText("Registered Minigames")
		for i in len(Coordinator.miniframes):
			var frame: Miniframe = Coordinator.miniframes[i]
			# Just in case there's two miniframes with the same node name
			# the ##i is there to distinguish between them.
			DebugComponents.MiniframeNode(DebugUtil.node_name(frame) + "##" + str(i), frame)
		
		ImGui.End()
