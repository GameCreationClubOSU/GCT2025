extends GridContainer
class_name Minefield

enum State {WON, LOST, GAMING}

signal flag_count_changed

@export var mine_count = 10
@export var tile_preset: PackedScene
@export var rows: int = 1
# Use the columns field of grid container for columns

var tiles: Array[MineTile] = []
var _random: RandomNumberGenerator
var _revealed_tiles: int = 0
var flags_remaining = 0
var game_state: State = State.GAMING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_random = RandomNumberGenerator.new()
	flags_remaining = mine_count
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
	for tile in tiles:
		tile.queue_free()
	tiles.clear()
	
	for row in rows:
		for column in columns:
			var index := row * columns + column
			var new_tile: MineTile = tile_preset.instantiate()
			add_child(new_tile)
			new_tile.revealed.connect(_on_reveal.bind(index))
			new_tile.flagged_changed.connect(_on_flagged_changed.bind(index))
			tiles.append(new_tile)
			
	for i in mine_count:
		var mine_index: = _random.randi_range(0, tiles.size() - 1)
		while tiles[mine_index].is_mine:
			mine_index = _random.randi_range(0, tiles.size() - 1)
			
		tiles[mine_index].is_mine = true
		
	for i in tiles.size():
		var adjacent_mines: = 0
		for neighbor_index in get_neighbors(i):
			if tiles[neighbor_index].is_mine:
				adjacent_mines += 1
			
		tiles[i].adjacent_mines = adjacent_mines
		
	game_state = State.GAMING
	_revealed_tiles = 0
	
func reveal_mines():
	for tile in tiles:
		if tile.is_mine:
			tile.reveal()
			
func disable_tiles():
	for tile in tiles:
		tile.enabled = false
		
func _on_flagged_changed(index: int) -> void:
	var tile: MineTile = tiles[index]
	if tile.flagged:
		flags_remaining -= 1
	else:
		flags_remaining += 1
	flag_count_changed.emit()
		
func _on_reveal(index: int) -> void:
	var tile: MineTile = tiles[index]
	_revealed_tiles += 1
	if tile.is_mine and game_state == State.GAMING:
		game_state = State.LOST
		tile.set_as_loss()
		reveal_mines()
		disable_tiles()
	elif _revealed_tiles >= rows * columns - mine_count:
		game_state = State.WON
		reveal_mines()
		disable_tiles()
	elif tile.adjacent_mines == 0 and not tile.is_mine:
		for neighbor_index in get_neighbors(index):
			var neighbor: MineTile = tiles[neighbor_index]
			neighbor.reveal()
				
