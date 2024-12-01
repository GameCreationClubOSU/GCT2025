class_name GridInventoryMenu
extends Control

signal slot_clicked(event: InputEventMouseButton, slot: ItemSlotDisplay, slot_index: int)

@export var columns: int = 8

@export var _slot_preset: PackedScene
@export var _slot_container: GridContainer
@export var _inventory_name_label: Label
@export var _slot_size: Vector2 = Vector2(72, 72) 

var inventory: ArrayInventory = null:
	get:
		return _inventory
	set(value):
		if is_instance_valid(value):
			pass

var _inventory: ArrayInventory = null
var _dragging: bool = false
var _drag_offset: Vector2
var _slot_displays: Array[ItemSlotDisplay] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _dragging:
		position = get_global_mouse_position() - _drag_offset
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
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
	
	# Unbind current inventory.
	# If no inventory is bound, method shouldn't error.
	unbind()
	
	_inventory = new_inventory
	_inventory_name_label.text = _inventory.name
	resize()
	
	var rows := ceili(_inventory.size / columns)
	_slot_displays.resize(_inventory.size)
	for row in rows:
		for column in columns:
			# This script is designed to able to take inventories that aren't rectangular
			# The last few slots that would be there just don't render.
			var index: int = row * columns + column
			if index < _inventory.size:
				var new_display: ItemSlotDisplay = _slot_preset.instantiate()
				new_display.slot = _inventory.slot_at(index)
				new_display.name = "Slot[%d][%d]" % [row, column]
				new_display.clicked.connect(func(event: InputEventMouseButton):
					slot_clicked.emit(event, new_display, index)
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
	# Calculating the total size of the grid element.
	var size_offset := size - _slot_container.size
	var rows := ceili(_inventory.size / columns)
	var grid_size := Vector2(columns, rows)
	grid_size *= _slot_size
	
	var separations := Vector2(_slot_container.get_theme_constant("h_separation", "GridContainer"), 
			_slot_container.get_theme_constant("v_separation", "GridContainer")) 
	# The -1 is because separation is only the space between the rows and columns. 
	separations *= Vector2(columns - 1, rows - 1)
	grid_size += separations
	
	_slot_container.size = grid_size
	_slot_container.columns = columns
	size = grid_size + size_offset
