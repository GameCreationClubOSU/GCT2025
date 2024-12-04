extends ItemSlotDisplay
## This is an independent slot that acts as the item selector for the player.
## Handles the click interactions with slots.
## Requires an [class InventoryManager] to be present in the minigame. 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot = ItemSlot.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_slot_clicked(event: InputEvent, clicked_slot: ItemSlot):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			ItemTransfer.standard_transfer(slot, clicked_slot)
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT:
			ItemTransfer.alternate_transfer(slot, clicked_slot)
			
