class_name Minigame
extends SubViewportContainer

signal clicked(minigame: Minigame)
@onready var viewport: SubViewport = $SubViewport
var enabled: bool = false:
	set(value):
		enabled = value
		viewport.process_mode = PROCESS_MODE_INHERIT if enabled else PROCESS_MODE_DISABLED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("minigames")
	enabled = false # Minigames off by default. 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
