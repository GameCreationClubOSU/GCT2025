extends Resource
class_name BubbleUpgrade

@export var upgrade_name: String = ""
@export var icon: Texture2D
@export_multiline var description: String = ""
var player: RogueBubblePlayer

func count_self(array: Array[BubbleUpgrade]) -> int:
	var sum: int = 0
	for item in array:
		if item.upgrade_name == upgrade_name:
			sum += 1
	return sum
		
func on_add(target: RogueBubblePlayer) -> void:
	self.player = target

func on_hit(damage: int, _upgrade_stack: Array[BubbleUpgrade]) -> int:
	return damage
	
func on_move(movement: Vector2, _upgrade_stack: Array[BubbleUpgrade]) -> Vector2:
	return movement
