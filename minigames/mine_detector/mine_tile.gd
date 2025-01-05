extends Control
class_name MineTile

signal revealed
signal flagged_changed

## These are close-ish to the orginal minesweeper colors
## Many of the colors were changed for contrast reasons
static var colors: Array[Color] = [
	Color.WHITE, # 0 doesn't have a color, but we still need a value here
	Color.DODGER_BLUE,
	Color.LIME_GREEN,
	Color.ORANGE_RED,
	Color.CORNFLOWER_BLUE,
	Color.CRIMSON,
	Color.CYAN,
	Color.GOLD,
	Color.PURPLE,
]

@export var cover: Control
@export var mine: Control
@export var number: Label
@export var flag: Control
@export var loss: Control
@export var enabled: bool = true

var adjacent_mines: int = 0
var is_mine: bool = false
var flagged: bool = false:
	set(value):
		if not is_revealed and enabled:
			flagged = value
			flag.visible = value
			flagged_changed.emit()
var is_revealed: bool = false
var label_settings = []

## This value is used for the button.
var _pressed_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mine.visible = false
	number.visible = false
	flag.visible = false
	cover.gui_input.connect(_on_press)
	loss.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_as_loss() -> void:
	loss.visible = true
	
func _on_press(event: InputEvent):
	if event is not InputEventMouseButton:
		return 
		
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.is_pressed():
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_pressed_time = Time.get_unix_time_from_system()
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT:
			flagged = !flagged
	elif mouse_event.is_released() and mouse_event.button_index == MOUSE_BUTTON_LEFT:
		# If the player holds for some time, there's a good chance they want to 
		# not actually reveal the tile.
		var time_elapsed := Time.get_unix_time_from_system() - _pressed_time
		if time_elapsed <= 0.1 or get_global_rect().has_point(mouse_event.global_position):
			reveal()
	

func reveal() -> void:
	if not enabled:
		return
	if is_revealed:
		return 
	elif flagged:
		return
	
	is_revealed = true
	cover.visible = false
	if is_mine:
		mine.visible = true
	elif adjacent_mines > 0:
		number.label_settings = number.label_settings.duplicate()
		number.label_settings.font_color = colors[adjacent_mines]
		number.text = str(adjacent_mines)
		number.visible = true
	
	revealed.emit()
