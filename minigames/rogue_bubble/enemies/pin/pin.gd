extends AnimatableBody2D

@export var target: Node2D
var timer := 5.0
@export var speed := 100.0
@export var sprite: Sprite2D
var direction := Vector2.UP
var moving := false;
var relative_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	if not moving:
		global_position = target.global_position + relative_position
		timer -= delta
		sprite.self_modulate = Color(1 - clamp(timer / 6, 0 , 1), 0, clamp(timer / 6, 0 , 1), 1)
		if timer <= 0:
			direction = (target.global_position - global_position).normalized()
			moving = true

func _physics_process(delta: float) -> void:
	if not moving:
		return
	var collision := move_and_collide(direction * speed * delta)
	if not is_instance_valid(collision):
		return
	var collider := collision.get_collider()
	if not is_instance_valid(collider):
		return
		
	if collider is RogueBubblePlayer:
		var player := collider as RogueBubblePlayer
		player.hit(1)
	queue_free()
	
## Called by the spawning node
func spawn(player: RogueBubblePlayer) -> void:
	target = player
	global_rotation = Vector2.DOWN.angle_to(target.global_position - global_position)
	relative_position = global_position - player.global_position
	timer = randf_range(1, 4)
	speed += randf_range(-30, 30)
