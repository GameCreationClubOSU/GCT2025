class_name MinigameManagerDebug
extends DebugModule

func render_debug() -> void:
	var enabled_ref := [enabled]
	if ImGui.Begin(menu_name, enabled_ref):
		enabled = enabled_ref[0]
		var parent: Node = get_parent()
		if parent is not MinigameManager:
			ImGui.Text("Parent is not a MinigameManager!")
			ImGui.End()
			return
		var minigame_manager: MinigameManager = parent as MinigameManager
		
		ImGui.SeparatorText("Registered Minigames")
		for frame in minigame_manager.miniframes:
			ImGui.Text(DebugUtil.node_name(frame))
		
		ImGui.End()
