extends PointLight2D

signal lighting_changed(_coords : PackedVector2Array)

@export var light_radius : float = 300
@export var number_of_casts : int = 360
@onready var TileMapRef = get_node("/root/Main/Frame/ShadowsAndAlchemy/SubViewport/World/TileMap")

var current_tilemap: TileMap
var light_tiles : Array

enum TerrainType {
	LIGHT = 1,
	SHADOW = 2,
	LUMINOUS = 4
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# use global coordinates, not local to node
	var space_state = get_world_2d().direct_space_state
	#print(result.get("rid", null))
	
	light_tiles.clear()
	
	var degree_spacing : float = 2*PI/number_of_casts
	var current_degree : float = 0
	for i in number_of_casts:
		var x : float
		var y : float
		x = cos(current_degree) * light_radius + self.position.x
		y = sin(current_degree) * light_radius + self.position.y
		var query = PhysicsRayQueryParameters2D.create(Vector2(self.position.x, self.position.y), Vector2(x, y))
		query.collision_mask = 2
		#light physics layer is bit 1, value 2
		var result = space_state.intersect_ray(query)
		current_degree += degree_spacing
		if result.get("collider",  null) is TileMap:
			_process_tilemap_collision(result.get("collider", null), result.get("rid", null))
	if TileMapRef is CustomTileMap:
		TileMapRef.append_coords(light_tiles)




func _process_tilemap_collision(body: Node2D, body_rid: RID) -> void:
	current_tilemap = body
	var collided_tile_coords : Vector2i = current_tilemap.	get_coords_for_body_rid(body_rid)
	if  !light_tiles.has(collided_tile_coords):
		light_tiles.append(collided_tile_coords)


func _draw():
	#_draw_ray_traces()
	pass
	
func _draw_ray_traces():
	var degree_spacing : float = 2*PI/number_of_casts
	var current_degree : float = 0
	for i in number_of_casts:
		var x : float
		var y : float
		x = cos(current_degree) * light_radius
		y = sin(current_degree) * light_radius
		draw_line(Vector2(0, 0), Vector2(x, y), Color.RED, 2.0)
		
		current_degree += degree_spacing
