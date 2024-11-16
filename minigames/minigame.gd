class_name Minigame
extends SubViewportContainer

signal clicked(minigame: Minigame)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("minigames")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
