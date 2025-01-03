extends Control
class_name MineTile

signal revealed

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

var adjacent_mines: int = 0
var is_mine: bool = false
var flagged: bool = false:
	set(value):
		if not is_revealed:
			flagged = value
			flag.visible = value
var is_revealed: bool = false
var label_settings = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mine.visible = false
	number.visible = false
	flag.visible = false
	cover.gui_input.connect(_on_press)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_press(event: InputEvent):
	if event is InputEventMouseButton and event.is_released():
		var mouse_event: InputEventMouseButton = event
		if get_global_rect().has_point(mouse_event.global_position):
			if mouse_event.button_index == MOUSE_BUTTON_LEFT:
				reveal()
			elif mouse_event.button_index == MOUSE_BUTTON_RIGHT:
				flagged = !flagged

func reveal() -> void:
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
