class_name ItemSlot
extends Resource

## A unit of inventory storage.
## Everything that needs store objects should use this class, including temporary stores of items.
## ItemSlots should be stable and should live as long as their parent objects.
## That means do not clear out ItemSlots by creating new ones, use clear method instead.
## Changing a ItemSlot's items should be done with internal methods. 
## Replacing the items should use [method Swap] with a temporary ItemSlot.
## DO NOT USE _amount and _item_type directly unless you know what you're doing.
##
## Further details:
## Generally, this class tries to be as fool-proof as possible (if user sticks to
## established methods and properties.) General guarantees are as follows:
## - Amount is always >= 0
## - If either _item_type is null or _amount == 0, the ItemSlot is considered empty.
## - Empty slots have amount == 0 and item_type == null. 
## - Amount should never exceed the max_stack in item_type.
## - Changes to slot should emit a changed signal.

## The amount of items in the slot.
@export var amount: int:
	get:
		return _amount if is_instance_valid(_item_type) else 0
	set(value):
		if is_instance_valid(_item_type):
			_amount = clampi(value, 0, _item_type.max_stack)
		else:
			_amount = 0
			
		if _amount <= 0:
			_item_type = null
			
		emit_changed()
			
## The type of item in the slot. Emptying out the slot will reset this to null.
## Avoid setting this directly.
@export var item_type: ItemType:
	get:
		return _item_type if _amount > 0 else null
	set(value):
		_item_type = value
		# Max stack of new item_type might be lower than the old one.
		if (_amount > 0 and is_instance_valid(_item_type)):
			_amount = clampi(_amount, 0, _item_type.max_stack)
		
		emit_changed()

## Internal backing field for amount. Do not manipulate directly unless you
## know what you're doing!
var _amount: int = 1
## Internal backing field for item_type. Do not manipulate directly unless you
## know what you're doing!
var _item_type: ItemType = null

## Returns true if the slot is empty, false otherwise.
func is_empty() -> bool:
	return amount <= 0

## Returns true if the slot is full, false otherwise.
## Returns false if the slot has no items.
func is_full() -> bool:
	return is_instance_valid(_item_type) and amount >= _item_type.max_stack 
	
## Gets the texture of the item_type.
## If item_type is null, then this method will return null.
func get_texture() -> Texture2D:
	return item_type.texture if is_instance_valid(item_type) else null
	
## Moves items from [param other] onto self. Returns the amount transferred.
##
## If [param max_amount] is >= 0, method will try to move that amount. 
func transfer_from(other: ItemSlot, max_amount: int) -> int:
	# Method uses backing fields instead of properties for performance.
	# Be careful editing this method if you don't know what you're doing.
	
	# Guard clauses. These won't change the object 
	# so they don't need to emit_changed and can return directly.
	if (other.is_empty()):
		return 0
	if (max_amount != null and max_amount <= 0):
		return 0
	if (other == self):
		return 0
	
	var transferred := 0
	if (is_empty()):
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
	
## Moves as many items as possible from [param other] onto self. 
## Returns the amount transferred. 
func transfer_all(other: ItemSlot) -> int:
	if is_instance_valid(other._item_type):
		return transfer_from(other, other._item_type.max_stack)
	
	return 0
	
## Returns true if [param other] has items that are stackable with this slot.
## If either slot is empty, will return true. 
## Is commutative, i.e. self.stackable_with(other) == other.stackable(self
func stackable_with(other: ItemSlot):
	return _item_type == other._item_type or is_empty() or other.is_empty()
	
## Swaps items with [param other]
func swap(other: ItemSlot) -> void:
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