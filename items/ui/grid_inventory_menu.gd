class_name GridInventoryMenu
extends Control
## A menu that displays an [class ArrayInventory].
## Inventory is displayed as a grid, filled out from left to right, top to bottom.

## Fires whenever any of the slots in the inventory are interacted with (i.e. a _gui_input)
signal slot_interacted(event: InputEvent, slot: ItemSlotDisplay, slot_index: int)

## How many columns are in the menu.
@export var columns: int = 8
## Whether or not this menu should be draggable.
@export var draggable: bool = true:
	set(value):
		draggable = value
		if not value:
			_dragging = false

## The inventory that the grid menu is displaying.
@export var inventory: ArrayInventory = null:
	get:
		return _inventory
	set(value):
		if is_node_ready():
			if is_instance_valid(value):
				bind_to_inventory(value)
			else:
				unbind()
		else:
			_inventory = value

@export_category("Controls")
## GridContainer node that all the nodes will go under.
@export var _slot_container: GridContainer
## Label that will display the inventory name.
@export var _inventory_name_label: Label
## A scene with [class ItemSlotDisplay] as its root.
## This will be instantiated for all the slots in the grid.
@export var _slot_preset: PackedScene
## Size of the individual slots.
@export var _slot_size: Vector2 = Vector2(72, 72)

## Internal backing field for inventory. Don't access directly.
var _inventory: ArrayInventory = null

## True if the menu is being dragged.
var _dragging: bool = false
## Offset from the controls position to where the mouse clicked it when the drag started.
## Used for calculating where the menu should move to after a drag.
var _drag_offset: Vector2

## Storage for all the slots created by the class.
var _slot_displays: Array[ItemSlotDisplay] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(_inventory):
		bind_to_inventory(_inventory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _dragging:
		position = get_global_mouse_position() - _drag_offset
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if draggable:
				if mouse_event.pressed:
					_dragging = true
					_drag_offset = get_global_mouse_position() - position
				else:
					_dragging = false
			accept_event()
		
## Binds this display to [param new_inventory]
func bind_to_inventory(new_inventory: ArrayInventory) -> void:
	if not is_instance_valid(new_inventory):
		push_error("Attempted to bind inventory display to invalid inventory!")
		return
	
	# Unbind current inventory.
	# If no inventory is bound, method shouldn't error.
	unbind()
	
	_inventory = new_inventory
	_inventory_name_label.text = _inventory.inventory_name
	resize()
	
	var rows := ceili(_inventory.size / float(columns))
	_slot_displays.resize(_inventory.size)
	for row in rows:
		for column in columns:
			var index: int = row * columns + column
			# This script is designed to able to take inventories that aren't rectangular
			# The last few slots that would be there just don't render.
			# Therefore, it's possible for the loop to try access a index that's out of bounds.
			# This is to prevent that
			if index < _inventory.size:
				var new_display: ItemSlotDisplay = _slot_preset.instantiate()
				new_display.slot = _inventory.slot_at(index)
				new_display.name = "Slot[%d][%d]" % [row, column]
				new_display.interacted.connect(func(event: InputEvent):
					slot_interacted.emit(event, new_display, index)
				)
				_slot_container.add_child(new_display)
				_slot_displays[index] = new_display

## Unbinds current inventory and frees all the slots.
func unbind() -> void:
	_inventory = null
	for display in _slot_displays:
		display.queue_free()
	_slot_displays.clear()

## Resizes the control to match inventory.
## Call whenever the size of the inventory changes.
func resize() -> void:
	# Point of this method is to calculate how big the _slot_container should be.
	# And then adding the padding (size_offset) back in.
	var size_offset := size - _slot_container.size

	# Calculating the total size of the grid element.
	var rows := ceili(_inventory.size / float(columns))
	var grid_size := Vector2(columns, rows)
	grid_size *= _slot_size
	
	var separations := Vector2(_slot_container.get_theme_constant("h_separation", "GridContainer"), 
			_slot_container.get_theme_constant("v_separation", "GridContainer")) 
	# The -1 is because separation is only the space between the rows and columns.
	# Good old fencepost error
	separations *= Vector2(columns - 1, rows - 1)
	grid_size += separations
	
	_slot_container.size = grid_size
	_slot_container.columns = columns
	size = grid_size + size_offset
