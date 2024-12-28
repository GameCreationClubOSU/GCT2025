class_name DebugComponents
extends Object
## Library for debug menu components
## ImGui GDScript is quite annoying to use. 
## There's no multiple returns so you have to use an array for i/o
## Functions with Input in the name are editable, the others are display only.
## If there's no array parameter, then it's probably a display only module.
##
## imgui-godot is from ImGui.NET and inherits C# capitalization conventions.
## For the sake of consistency, this class uses the same conventions.

static func InputVector2(label: String, v: Array):
	var vector: Vector2 = v[0]
	var vector_arr = [vector.x, vector.y]
	var changed = ImGui.InputFloat2(label, vector_arr)
	v[0] = Vector2(vector_arr[0], vector_arr[1])
	return changed

static func MiniframeNode(label: String, miniframe: Miniframe):
	if ImGui.TreeNode(label):
		ImGui.Text("Name: %s" % miniframe.frame_name)
		ImGui.Text("Enabled: %s" % miniframe.enabled)
		ImGui.Text("Auto Reset: %s" % miniframe.auto_reset)
		ImGui.Text("Scene Root: %s" % DebugUtil.node_name(miniframe.scene_root))
		ImGui.TreePop()

static func Inventory(label: String, inventory: ArrayInventory):
	if ImGui.TreeNode(label):
		for i in inventory.size:
			var slot: ItemSlot = inventory.slot_at(i)
			var type_name: String = "null"
			if is_instance_valid(slot.item_type):
				type_name = slot.item_type.item_id 
			ImGui.Text("%2d: Type: %s, Amount: %d" % [i, type_name, slot.amount])
			
		ImGui.TreePop()
		
	
