extends Control

@onready var world = $"../../"
@onready var game_instance : gameInstance = $"/root/GameInstance"

@onready var potion1_display = $MarginContainer/HBoxContainer/VBoxContainer/Potion1Display
@onready var potion2_display = $MarginContainer/HBoxContainer/VBoxContainer2/Potion2Display

enum PotionType {
	EMPTY = 1,
	LEAD = 2,
	TIN = 4,
	GLASS = 8
}

var potion1 : PotionType = PotionType.LEAD
var potion2 : PotionType = PotionType.GLASS

func _process(delta):
	potion1_display.text = PotionType.find_key(potion1)
	if potion1 == PotionType.TIN:
		potion1_display.text = "Invalid Potion"
	potion2_display.text = PotionType.find_key(potion2)
	if potion2 == PotionType.TIN:
		potion2_display.text = "Invalid Potion"

func _on_add_lead_1_pressed():
	match potion1:
		PotionType.EMPTY:
			potion1 = PotionType.LEAD
		PotionType.TIN:
			potion1 = PotionType.GLASS

func _on_add_tin_1_pressed():
	match potion1:
		PotionType.EMPTY:
			potion1 = PotionType.TIN
		PotionType.LEAD:
			potion1 = PotionType.GLASS

func _on_reset_1_pressed():
	potion1 = PotionType.EMPTY
	
func _on_add_lead_2_pressed():
	match potion2:
		PotionType.EMPTY:
			potion2 = PotionType.LEAD
		PotionType.TIN:
			potion2 = PotionType.GLASS

func _on_add_tin_2_pressed():
	match potion2:
		PotionType.EMPTY:
			potion2 = PotionType.TIN
		PotionType.LEAD:
			potion2 = PotionType.GLASS

func _on_reset_2_pressed():
	potion2 = PotionType.EMPTY
