class_name ItemDescriptor
extends Resource
## This class is to allow the user to add items to an inventory without
## trying to access a large data structure in the inspector.
## Designed for the [class ArrayInventory].

@export_range(0, 100, 1, "or_greater") var index: int = 0
@export var type: ItemType
@export_range(0, 100, 1, "or_greater") var amount: int = 0 
