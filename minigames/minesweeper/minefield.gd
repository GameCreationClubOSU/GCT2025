extends GridContainer

@export var mine_count = 10
@export var tile_preset: PackedScene
@export var rows: int = 1
# Use the columns field of grid container for columns

var tiles: Array[MineTile] = []

var _random: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_random = RandomNumberGenerator.new()
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func get_neighbors(i: int) -> Array[int]:
	var neighbors: Array[int] = []
	var has_left := i % columns != 0
	var has_right := i % columns != columns - 1
	var has_up := i >= columns
	var has_down := i < (rows - 1) * columns
	if has_left:
		neighbors.append(i - 1)
	if has_left and has_up:
		neighbors.append(i - columns - 1)
	if has_up:
		neighbors.append(i - columns)
	if has_right and has_up:
		neighbors.append(i - columns + 1)
	if has_right:
		neighbors.append(i + 1)
	if has_right and has_down:
		neighbors.append(i + columns + 1)
	if has_down:
		neighbors.append(i + columns)
	if has_left and has_down:
		neighbors.append(i + columns - 1)
	return neighbors

func generate() -> void:
	tiles.clear()
	for row in rows:
		for column in columns:
			var new_tile: MineTile = tile_preset.instantiate()
			add_child(new_tile)
			new_tile.revealed.connect(_on_reveal.bind(row * columns + column))
			tiles.append(new_tile)
			
	for i in mine_count:
		var mine_index = _random.randi_range(0, tiles.size() - 1)
		while tiles[mine_index].is_mine:
			mine_index = _random.randi_range(0, tiles.size() - 1)
			
		tiles[mine_index].is_mine = true
		
	for i in tiles.size():
		var adjacent_mines = 0
		for neighbor_index in get_neighbors(i):
			if tiles[neighbor_index].is_mine:
				adjacent_mines += 1
			
		tiles[i].adjacent_mines = adjacent_mines
		
func _on_reveal(index: int) -> void:
	var tile: MineTile = tiles[index]
	if tile.adjacent_mines == 0 and not tile.is_mine:
		for neighbor_index in get_neighbors(index):
			var neighbor: MineTile = tiles[neighbor_index]
			neighbor.reveal()
				
