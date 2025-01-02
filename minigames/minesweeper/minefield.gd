extends GridContainer

@export var tile_preset: PackedScene
@export var rows: int = 1
# Use the columns field of grid container for columns

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate() -> void:
	for row in rows:
		for column in columns:
			var new_tile = tile_preset.instantiate()
			add_child(new_tile)
