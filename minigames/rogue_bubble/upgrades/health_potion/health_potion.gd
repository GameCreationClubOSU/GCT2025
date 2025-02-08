extends BubbleUpgrade

@export var restore_amount: int = 2

func on_add(player: RogueBubblePlayer) -> void:
	player.health = clampi(player.health + restore_amount, 0, player.max_health)
