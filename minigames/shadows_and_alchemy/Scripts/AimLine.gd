extends Line2D

const GRAVITY = 490

var velocity = Vector2.ZERO

@onready var screen_size = get_viewport_rect().size
@onready var player : Player = get_parent()
@onready var projectile_velocity : float = Player.proj_speed


	
func _physics_process(delta):
	var target_position : Vector2 = get_global_mouse_position()
	
	var vel : Vector2 = projectile_velocity * (target_position - global_position).normalized()
	update_trajectory(vel, GRAVITY, delta)
	
func update_trajectory(vel: Vector2, gravity: float, delta: float) -> void:
	var max_points = 300
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	for i in max_points:
		add_point(pos)
		vel.y += gravity * delta
		pos += vel * delta
