class_name ArrayInventory
extends Node
## Simple inventory. Each slot in the inventory has an associated int index.
## Use existing methods wherever possible. If not, the underlying array is
## available as [member slots]. 

@export var size: int = 5:
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
	resize(size)
	
	# Filling in all the descriptors
	for descriptor in descriptors:
		if descriptor.index >= size:
			push_warning("Item descriptor index is out of bounds!")
		else:
			var slot = slots[descriptor.index]
			if is_instance_valid(slot.item_type):
				push_warning("Item descriptor is overwriting items in slot!")
			slot.item_type = descriptor.type
			slot.amount = descriptor.amount


## Resizes the inventory.
func resize(new_size: int) -> void:
	if new_size <= 0:
		push_error("Cannot set inventory size <= 0!")
		return
			
	slots.resize(new_size)
	for i in slots.size():
		if not is_instance_valid(slots[i]):
			slots[i] = ItemSlot.new()
			
	# If the inventory is shrinking resize will remove the old slots. No further action needed.

## Gets the total amount of items of type [param item_type] in the inventory.
func amount_of(item_type: ItemType) -> int:
	if not is_instance_valid(item_type):
		return 0
		
	var sum: int = 0
	for slot in slots:
		if slot.item_type == item_type:
			sum += slot.amount
			
	return sum

## Transfers items from [param provider] to self. 
## Will transfer a max of [param max_amount] but might transfer less depending
## on what can be transferred.
## Returns the amount of items transferred.
func transfer_from(provider: ItemSlot, max_amount: int) -> int:
	# Transferring negative items should get caught by [class ItemSlot] anyway.
	# This is just in case.
	max_amount = max(max_amount, 0) 
	var amount_transferred: int = 0
	# mini is min_integer, not synonym for small
	var transfer_limit: int = mini(max_amount, provider.amount)
	# Prefer slots with stackable slots first.
	for slot in slots:
		if transfer_limit <= 0:
			break
		elif slot.stackable_with(provider):
			var transferred = slot.transfer_from(provider, transfer_limit)
			transfer_limit -= transferred
			amount_transferred += transferred
			
	# General loop
	for slot in slots:
		if transfer_limit <= 0:
			break
		var transferred = slot.transfer_from(provider, transfer_limit)
		transfer_limit -= transferred
		amount_transferred += transferred
	
	return amount_transferred

## Transfers items from [param provider] to self.
## Similar to [method transfer_from] but will try 
## to transfer all items from [param provider] to self.
## Returns the amount of items transferred.
func transfer_all(provider: ItemSlot) -> int:
	return transfer_from(provider, provider.amount)
	
## Attempts to find the first slot that contains items of [param type]
## Returns negative index if not found.
func first_slot_of(type: ItemType) -> int:
	if not is_instance_valid(type):
		push_error("Invalid item type!")
		return -1
	
	for i in slots.size():
		if slots[i].item_type == type:
			return i
	
	return -1
	
## Returns true if [param slot] is in inventory. False otherwise.
func has_slot(slot: ItemSlot) -> bool:
	return slots.has(slot)

## Gets the slot at [param index]
func slot_at(index: int) -> ItemSlot:
	return slots[index]
