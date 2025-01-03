extends Control

@export var flag_counter: Label
@export var timer: Label
@export var minefield: Minefield
@export var reset_button: BaseButton

var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minefield.flag_count_changed.connect(update_flags)
	reset_button.pressed.connect(reset)
	update_flags()

func update_flags():
	flag_counter.text = "%03d" % min(minefield.flags_remaining, 999)

func reset():
	time = 0
	minefield.generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if minefield.game_state == Minefield.State.GAMING:
		time += delta
		timer.text = "%03d" % min(time, 999)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		reset()
		get_viewport().set_input_as_handled()
