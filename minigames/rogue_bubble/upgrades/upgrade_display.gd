extends VBoxContainer

@export var player: RogueBubblePlayer
@export var upgrade_preset: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_preset.visible = false
	player.upgrade_added.connect(add_upgrade)
	
func add_upgrade(upgrade: BubbleUpgrade):
	var new_panel: Node = upgrade_preset.duplicate()
	var icon: TextureRect = new_panel.get_node("Icon") as TextureRect
	icon.texture = upgrade.icon
	new_panel.tooltip_text = upgrade.upgrade_name + "\n" + upgrade.description
	new_panel.visible = true
	add_child(new_panel)
	
