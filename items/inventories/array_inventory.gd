class_name ArrayInventory
extends Node
## Simple inventory. Each slot in the inventory has an associated int index.
## Use existing methods wherever possible. If not, the underlying array is
## available as [member slots]. 

var size: int:
	get():
		return slots.size()
	set(value):
		push_error("Tried to set size directly! Use the resize method instead.")

## Display name of the inventory.
@export var inventory_name: String = ""

@export var slots: Array[ItemSlot] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fill_blanks()

## Resizes the inventory. Also fills in nulls in the slots array with
## blank ItemSlots
func resize(new_size: int) -> void:
	if new_size <= 0:
		push_error("Cannot set inventory size <= 0!")
		return
			
	slots.resize(new_size)
	_fill_blanks()
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
##
## Will transfer a max of [param max_amount] but might transfer less depending
## on what can be transferred. Will prefer to stack with slots with the same item_type first.
## Returns the amount of items transferred.
func transfer_from(provider: ItemSlot, max_amount: int) -> int:
	# Transferring negative items should get caught by [class ItemSlot] anyway.
	# This is just in case.
	max_amount = max(max_amount, 0) 
	var amount_transferred: int = 0
	# mini is min_integer, not synonym for small
	var transfer_limit: int = mini(max_amount, provider.amount)
	# Prefer slots with the same item_type first.
	for slot in slots:
		if transfer_limit <= 0:
			break
		elif slot.item_type == provider.item_type:
			var transferred: int = slot.transfer_from(provider, transfer_limit)
			transfer_limit -= transferred
			amount_transferred += transferred
			
	# General loop
	for slot in slots:
		if transfer_limit <= 0:
			break
		var transferred: int = slot.transfer_from(provider, transfer_limit)
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
	
## Clears all items in inventory.
func clear() -> void:
	for slot in slots:
		slot.clear()

## Fills in nulls in the slots array with blank ItemSlots.
## Should never be needed outside of the class.
func _fill_blanks() -> void:
	for i in slots.size():
		if not is_instance_valid(slots[i]):
			slots[i] = ItemSlot.new()
