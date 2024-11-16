extends TileMap
class_name CustomTileMap

var all_tiles
var coords : PackedVector2Array
enum TerrainType {
	LIGHT = 1,
	SHADOW = 2,
	LUMINOUS = 4
}
var lighting_update_length : float = .05
var lighting_update_timer : float = 1

func _ready():
	all_tiles = get_used_cells(0)

func _physics_process(_delta):
	lighting_update_timer += _delta
	if lighting_update_timer >= lighting_update_length:
		lighting_update_timer = 0
		for index in all_tiles.size():
			var tile_data = get_cell_tile_data(0, all_tiles[index])
			var terrain_data = tile_data.get_custom_data_by_layer_id(0)
			if terrain_data == TerrainType.LUMINOUS:
				pass
			elif coords.has(all_tiles[index]): #Set light tile
				set_cell(0, all_tiles[index], 1, get_cell_atlas_coords(0, all_tiles[index]))
				tile_data.set_custom_data_by_layer_id(0,TerrainType.LIGHT)
			else: #Set dark tile
				set_cell(0, all_tiles[index], 0, get_cell_atlas_coords(0, all_tiles[index]))
				tile_data.set_custom_data_by_layer_id(0,TerrainType.SHADOW)
		coords.clear()

func append_coords(new_coords : PackedVector2Array):
	coords.append_array(new_coords)
