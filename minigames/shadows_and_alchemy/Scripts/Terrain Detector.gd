class_name TerrainDetector
extends Area2D

const bitmask: int = 255

enum TerrainType {
	DEFAULT = 1,
	CLIMBABLE = 2,
	SHADOW = 4
}

var current_tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMap:
		_process_tilemap_collision(body, body_rid)
	pass # Replace with function body.

func _process_tilemap_collision(body: Node2D, body_rid: RID) -> void:
	current_tilemap = body
	
	var collided_tile_coords = current_tilemap.	get_coords_for_body_rid(body_rid)
	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index, collided_tile_coords)
		if !tile_data is TileData:
			continue
		var custom_data = tile_data.get_custom_data_by_layer_id(0)
		
