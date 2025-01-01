class_name ItemTransfer
extends Object
## Utility library for player item transfer protocols.
## Generally, source will refer to the ItemSlot the player's holding,
## and destination will refer to the slot they're clicking on. 
## See [class SelectionSlot] for examples.

## Standard left-click behavior.
## Transfer from source to destination if both slots contain the same items,
## swap otherwise.
static func standard_transfer(source: ItemSlot, destination: ItemSlot):
	if not source.is_empty() and destination.stackable_with(source):
		destination.transfer_all_from(source)
	elif source.is_empty():
		source.transfer_all_from(destination)
	elif not (source.block_transfer_in or source.block_transfer_out 
			or destination.block_transfer_in or destination.block_transfer_out):
		destination.swap(source)
		
## Standard right-click behavior.
static func alternate_transfer(source: ItemSlot, destination: ItemSlot):
	if source.is_empty():
		# Take half, round up
		source.transfer_from(destination, ceili(destination.amount / 2.0))
	else:
		if destination.stackable_with(source):
			destination.transfer_from(source, 1)
		elif not (source.block_transfer_in or source.block_transfer_out 
			or destination.block_transfer_in or destination.block_transfer_out):
			destination.swap(source)
