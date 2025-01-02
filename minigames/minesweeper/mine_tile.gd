extends Control

signal revealed

@export var cover: BaseButton
@export var mine: Control
@export var number: Label

@export var adjacent_mines: int = 0
@export var is_mine: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mine.visible = false
	number.visible = false
	cover.pressed.connect(reveal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reveal() -> void:
	cover.visible = false
	if is_mine:
		mine.visible = true
	elif adjacent_mines > 0:
		number.text = str(adjacent_mines)
		number.visible = true
		
