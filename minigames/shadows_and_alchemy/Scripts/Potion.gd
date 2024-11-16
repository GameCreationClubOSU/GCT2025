extends RigidBody2D

var velocity : Vector2 = Vector2.ZERO
var dir : Vector2 = Vector2.ZERO

@onready var lead_block : PackedScene = preload("res://minigames/shadows_and_alchemy/Scenes/lead_block.tscn")
@onready var block_counter = get_node("/root/Main/Frame/ShadowsAndAlchemy/SubViewport/World/BlockCounter")

func _physics_process(delta):
	$Sprite2D.rotate(.1)
	var collision = move_and_collide(velocity * delta)
	if collision:
		var block = lead_block.instantiate()
		block_counter.add_child(block)
		if block is RigidBody2D:
			block.position = global_position
		if block_counter is BlockCounter:
			block_counter.add_block(block)
		queue_free()
