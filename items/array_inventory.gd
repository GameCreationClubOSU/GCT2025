class_name ArrayInventory
extends Node

## Simple inventory. Each slot in the inventory has an associated int index.
## TODO: Allow runtime resizing.

@export var size: int = 5:
	get:
		if is_node_ready():
			return slots.size()
		else:
			return size
	set(value):
		if value <= 0:
			push_error("Cannot set inventory size <= 0!")
			return
		if is_node_ready():
			resize(value)
			
		size = value

## Desciptors for all the items that should be placed in here at runtime.
## Adding anything to this after runtime does nothing.
@export var descriptors: Array[ItemDescriptor] = []
## Display name of the inventory.
@export var inventory_name: String = ""

var slots: Array[ItemSlot] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	
	# Filling in all the descriptors
	for descriptor in descriptors:
		if descriptor.index >= size:
			push_warning("Item descriptor index is out of bounds!")
		else:
			var slot = slots[descriptor.index]
			if is_instance_valid(slot.item_type):
				push_warning("Item descriptor is overwriting items in slot!")
			slot.item_type = descriptor.item_type
			slot.amount = descriptor.amount


func resize(new_size: int) -> void:
	if new_size <= 0:
		push_error("Cannot set inventory size <= 0!")
		return
			
	var old_size: int = slots.size()
	slots.resize(new_size)
	if new_size > old_size:
		for i in range(old_size, new_size):
			slots[i] = ItemSlot.new()
	# If new_size is smaller (i.e. the inventory is shrinking) resize will
	# remove the old slots. No further action needed.
