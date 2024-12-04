class_name ItemSlotDisplay
extends Control

signal clicked(event: InputEventMouseButton)

@export var clickable: bool = true
@export var _item_texture: TextureRect
@export var _amount_label: Label
@export var slot: ItemSlot = ItemSlot.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_instance_valid(slot):
		slot = ItemSlot.new()
		
	update_display()
	
func _gui_input(event: InputEvent) -> void:
	if clickable and event is InputEventMouseButton:
		accept_event()
		clicked.emit(event)

func update_display() -> void:
	var texture: Texture2D = null
	var amount_text: String = ""
	tooltip_text = "" # Field of Control.
	
	if is_instance_valid(slot) and not slot.is_empty():
		texture = slot.get_texture()
		# If the max stack is only one, just show the icon and not the number.
		amount_text = str(slot.amount) if slot.item_type.max_stack > 1 else ""
		tooltip_text = slot.item_type.name + "\n" + slot.item_type.description
		
	if is_instance_valid(_item_texture):
		_item_texture.texture = texture
		
	if is_instance_valid(_amount_label):
		_amount_label.text = amount_text
