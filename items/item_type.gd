class_name ItemType
extends Resource

## Defines a set of immutable properties about a type of item.
## Does not store data about a specific item.
## This should always be an external resource (i.e. saved as a separate file)
## rather than built-in to a scene. 
## 
## For storing items in inventories, see [ItemSlot].

## String defining the id of the item type. Must be unique among item types.
## Value should be in snake case "this_is_an_example_item_id".
@export var item_id: String = ""

## Display name of the item. This is what the player sees.
@export var name: String = ""

## Description of the item when you hover over it.
@export var description: String = ""

## Texture representing the item in the player's inventory.
@export var texture: Texture2D

## Max size of a stack of this item.
@export var max_stack: int
