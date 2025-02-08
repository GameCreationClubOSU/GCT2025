extends BubbleUpgrade

@export var health_increase: int = 1

func on_add(target: RogueBubblePlayer) -> void:
	target.health += health_increase
	target.max_health += health_increase
