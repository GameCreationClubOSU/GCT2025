class_name ItemSlotDisplay
extends Control

## Fires whenever the slot has been interacted with in some way (i.e. _gui_input)
signal interacted(event: InputEvent)

## If false, the display can't be interacted with and will never fire the [signal interacted] signal.
@export var interactable: bool = true
## The [class TextureRect] that will be used to display the item_texture.
@export var _item_texture: TextureRect
## The [class Label] that will be used to display the amount in the slot.
@export var _amount_label: Label
## The slot that this display is displaying.
@export var slot: ItemSlot = ItemSlot.new():
	set(value):
		if is_instance_valid(slot) and slot.changed.is_connected(update_display):
			slot.changed.disconnect(update_display)
		slot = value
		if is_instance_valid(value):
			slot.changed.connect(update_display)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_instance_valid(slot):
		slot = ItemSlot.new()
		
	update_display()
	
func _gui_input(event: InputEvent) -> void:
	if interactable:
		accept_event()
		Coordinator.alert_slot_interacted(event, slot, self)
		interacted.emit(event)
		
# Updates the display's view of its ItemSlot.
func update_display() -> void:
	var texture: Texture2D = null
	var amount_text: String = ""
	tooltip_text = "" # tooltip_text is a field of Control.
	
	if is_instance_valid(slot) and not slot.is_empty():
		texture = slot.get_texture()
		# If the max stack is only one, just show the icon and not the number.
		amount_text = str(slot.amount) if slot.item_type.max_stack > 1 else ""
		tooltip_text = slot.item_type.name + "\n" + slot.item_type.description
		
	# If the control nodes aren't set, assume that the user wants to not show them. 
	if is_instance_valid(_item_texture):
		_item_texture.texture = texture
		
	if is_instance_valid(_amount_label):
		_amount_label.text = amount_text
