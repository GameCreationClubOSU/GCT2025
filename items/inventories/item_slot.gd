@tool
class_name ItemSlot
extends Resource
## A unit of inventory storage.
## Everything that needs to store objects should use this class, including temporary stores of items.
## Most ItemSlots should be stable and should live as long as their parent objects.
## That means do not clear out ItemSlots by creating new ones, use clear method instead.
## Changing a ItemSlot's items should be done with methods. 
## Try to avoid setting amount and item_type directly. Use the given methods instead.
## DO NOT USE _amount and _item_type directly unless you know what you're doing.
##
## Further details:
## Generally, this class tries to be as fool-proof as possible (if user sticks to
## established methods and properties.) Methods have lots of checks, sometimes redundant. 
## General guarantees are as follows:
## - Amount is always >= 0
## - If either _item_type is null or _amount == 0, the ItemSlot is considered empty.
## - Amount should never exceed the max_stack in item_type.
## - Changes to slot should emit a changed signal.

# Order matters here. It's important that Godot sets item_type first
# and not amount. Otherwise the internal checks will clamp amount to 0.

## The type of item in the slot. Emptying out the slot will reset this to null.
## Avoid setting this directly.
@export var item_type: ItemType:
	get:
		return _item_type
	set(value):
		_item_type = value
		# Max stack of new item_type might be lower than the old one.
		if (_amount > 0 and is_instance_valid(_item_type)):
			_amount = clampi(_amount, 0, _item_type.max_stack)
		
		emit_changed()

## The amount of items in the slot.
## Prefer [method add] and [method add_item] over setting this directly.
@export var amount: int:
	get:
		return _amount if is_instance_valid(_item_type) else 0
	set(value):
		if is_instance_valid(_item_type):
			_amount = clampi(value, 0, _item_type.max_stack)
		else:
			if value > 0:
				push_warning("Attempted to set item amount while item_type is invalid!")
			_amount = 0
			
		emit_changed()

## If true, slot block transfers into the slot.
## Only blocks transfer_from. Does not block other methods.
@export var block_transfer_in: bool = false:
	set(value):
		block_transfer_in = value
		emit_changed()
## If true, slot will allow items to be inserted
## Only blocks transfer_from. Does not block other methods.
@export var block_transfer_out: bool = false:
	set(value):
		block_transfer_out = value
		emit_changed()
## If true, the ItemSlot will not change item_type even when empty.
## Use this if there is a slot that should only be able to take one ItemType.
@export var filtered: bool = false:
	set(value):
		filtered = value
		emit_changed()

## Internal backing field for item_type. Do not manipulate directly unless you
## know what you're doing!
var _item_type: ItemType = null
## Internal backing field for amount. Do not manipulate directly unless you
## know what you're doing!
var _amount: int = 0

func _init(new_item_type: ItemType = null, new_amount: int = 0) -> void:
	if is_instance_valid(new_item_type):
		_item_type = new_item_type
		_amount = clampi(new_amount, 0, _item_type.max_stack)
	else:
		_amount = 0
		_item_type = null

## Returns true if the slot is empty, false otherwise.
func is_empty() -> bool:
	return amount <= 0

## Returns true if the slot is full, false otherwise.
## Returns false if the slot has no items.
func is_full() -> bool:
	return is_instance_valid(_item_type) and amount >= _item_type.max_stack 
	
## Gets the texture of the item_type.
## If slot is empty, then this method will return null.
func get_texture() -> Texture2D:
	## If the item is filtered, return the texture still
	## to communicate what the filter ItemType is.
	if not is_empty() or (is_instance_valid(_item_type) and filtered):
		return _item_type.texture
	else:
		return null
	
## Adds [param addend] to the existing stack. 
## Use a negative [param addend] to remove items.
## Will not add more than max_stack of item_type.
## If slot is empty, nothing happens.
## Returns amount added.
func add(addend: int) -> int:
	if is_empty():
		return 0
		
	var amount_before: int = _amount
	_amount = clampi(_amount + addend, 0, _item_type.max_stack)
	emit_changed()
	return _amount - amount_before
	
## Adds [param addend] number of items of the given [param type] to the slot.
## If the adding item cannot be stacked with the current amount, no items
## will be added.
## Returns amount added.
func add_item(type: ItemType, addend: int) -> int:
	if not is_instance_valid(type):
		push_warning("Tried to add invalid item type to ItemSlot!")
		return 0
		
	# Filtered slots should not change item types
	if is_empty() and not filtered:
		_item_type = type
		 # If _item_type is invalid, slot counts as empty but _amount isn't necessarily 0
		_amount = 0
	
	if _item_type == type:
		# Can't just use [method add] because that method has an empty check.
		# This method can add items to an empty ItemSlot
		var amount_before: int = _amount
		_amount = clampi(_amount + addend, 0, _item_type.max_stack)
		emit_changed()
		return _amount - amount_before
	else:
		return 0
	
## Moves items from [param other] onto self. Returns the amount transferred.
##
## If [param max_amount] is > 0, method will try to move that amount. 
## Negative [param max_amount] will act as though max_amount == 0
func transfer_from(other: ItemSlot, max_amount: int) -> int:
	# There's a lot of weird edge cases with this method.
	# Be careful editing this method if you don't know what you're doing.
	
	# Guard clauses. These won't change the object 
	# so they don't need to emit_changed and can return directly.
	if (block_transfer_in):
		return 0
	if (other.block_transfer_out):
		return 0
	if (other.is_empty()):
		return 0
	if (max_amount <= 0):
		return 0
	if (other == self):
		return 0
	
	var transferred := 0
	if (is_empty() and not filtered):
		# If more slot specific data is added, this might need to be changed
		_item_type = other._item_type 
		# If _item_type is set to null, ItemSlot is "empty", 
		# but _amount might not be 0
		_amount = 0 
		
	if (stackable_with(other)):
		# other is not empty (checked by guard clause) 
		# And self._item_type == other._item_type, so self._item_type shouldn't be empty.
		transferred = _item_type.max_stack - _amount # Self capacity limit
		# This is a min_int, not the synonym for small
		transferred = mini(transferred, other._amount) # Don't take more than the other stack has
		if max_amount != null:
			transferred = mini(transferred, max_amount)
			
		_amount += transferred
		other.amount -= transferred # Using property here to trigger checks on other.
		
	emit_changed()
	return transferred
	
## Replaces the item_stack with the parameters.
## This method largely bypasses all the block and filter checks.
func replace(new_type: ItemType, new_amount: int) -> void:
	if not is_instance_valid(new_type):
		push_error("Attempted to replace ItemSlot's items with invalid type!")
		return
		
	_item_type = new_type
	_amount = clampi(new_amount, 0, _item_type.max_stack)
	
## Moves as many items as possible from [param other] onto self. 
## Returns the amount transferred. 
func transfer_all_from(other: ItemSlot) -> int:
	if is_instance_valid(other._item_type):
		return transfer_from(other, other._item_type.max_stack)
	
	return 0
	
## Returns true if [param other] has items that are stackable with this slot.
func stackable_with(other: ItemSlot):
	return _item_type == other._item_type or (is_empty() and not filtered)
	
## Swaps items with [param other]
func swap(other: ItemSlot) -> void:
	if filtered and other._item_type != _item_type:
		return
	
	# I miss C#
	# Probably the only place that C# is less verbose.
	var temp_type: ItemType = other._item_type
	other._item_type = _item_type
	_item_type = temp_type
	
	var temp_amount: int = other._amount
	other._amount = _amount
	_amount = temp_amount
	
	# Used the backing fields here so that the emit_changed signal is only
	# called once per swap.
	emit_changed()
	other.emit_changed()

## Removes all items in self.
func clear() -> void:
	_amount = 0
	_item_type = null
