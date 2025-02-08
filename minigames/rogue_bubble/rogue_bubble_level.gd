extends Node2D

enum { ACTIVE, INTERMISSION }

@export var round_duration: float = 10
@export var label: Label
@export var enemies: Node
@export var enemy_presets: Array[PackedScene]
@export var player: RogueBubblePlayer
var round_number: int = 0
var round_timer: float = 0

var state := INTERMISSION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.upgrade_added.connect(on_upgrade_added)
	end_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == ACTIVE:
		round_process(delta)
		
func on_upgrade_added(_upgrade: BubbleUpgrade):
	if state == INTERMISSION:
		start_round()
		
## Method is called when the game is active 
func round_process(delta: float) -> void:
	round_timer -= delta
	label.text = str(ceil(round_timer))
	if round_timer <= 0:
		end_round()
		
func start_round() -> void:
	round_number += 1
	round_timer = round_duration
	state = ACTIVE
	for i in round_number + 5:
		var new_enemy_packed: PackedScene = enemy_presets.pick_random() as PackedScene
		var new_enemy: Node = new_enemy_packed.instantiate() as Node
		var radius: float = randf_range(100, 300)
		var angle: float = randf_range(0, TAU)
		enemies.add_child(new_enemy)
		var spawn_offset: Vector2 = Vector2(cos(angle) * radius, sin(angle) * radius)
		new_enemy.global_position = spawn_offset + player.global_position
		if new_enemy.has_method("spawn"):
			new_enemy.spawn(player)

func end_round() -> void:
	state = INTERMISSION
	label.text = "CHOOSE UPGRADE"
	player.show_upgrades()
	for node in enemies.get_children():
		node.queue_free()
