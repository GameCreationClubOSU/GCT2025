extends CharacterBody2D
class_name Player
var can_use_glass : bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const proj_speed = 350

enum PotionType {
	EMPTY = 1,
	LEAD = 2,
	TIN = 4,
	GLASS = 8
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var lead_potion : PackedScene = preload("res://minigames/shadows_and_alchemy/Scenes/lead_potion.tscn")
@onready var clear_potion : PackedScene = preload("res://minigames/shadows_and_alchemy/Scenes/clear_potion.tscn")
# TODO: Figure out a better solution to the scene root problem
@onready var world = get_node("/root/Main/Frame/ShadowsAndAlchemy/SubViewport/World")

var local_potion1
var local_potion2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("reset"):
		GameInstance.load_current_level()
		pass
		
	get_local_potions()
	if Input.is_action_just_pressed("throw_potion1") && $Timer.time_left <= 0 && Engine.time_scale == 1 && local_potion1 != null:
		$Timer.start()
		var projectile = local_potion1.instantiate()
		world.add_child(projectile)
		if projectile is RigidBody2D:
			projectile.position = position
			projectile.linear_velocity = (get_global_mouse_position() - global_position).normalized() * proj_speed
	if Input.is_action_just_pressed("throw_potion2") && $Timer.time_left <= 0 && Engine.time_scale == 1 && local_potion2 != null:
		$Timer.start()
		var projectile = local_potion2.instantiate()
		world.add_child(projectile)
		if projectile is RigidBody2D:
			projectile.position = position
			projectile.linear_velocity = (get_global_mouse_position() - global_position).normalized() * proj_speed
		 
	move_and_slide()

func get_local_potions():
	match $PauseMenu.potion1:
		PotionType.LEAD:
			local_potion1 = lead_potion
		PotionType.GLASS:
			local_potion1 = clear_potion
		_:
			local_potion1 = null
	match $PauseMenu.potion2:
		PotionType.LEAD:
			local_potion2 = lead_potion
		PotionType.GLASS:
			local_potion2 = clear_potion
		_:
			local_potion2 = null
