extends MarginContainer

func _ready():
	$SickHappinessUI.visible = false
	$PetHappinessUI.visible = true

func _on_Tamagotchi_switch_to_pet() -> void:
	$SickHappinessUI.visible = false
	$PetHappinessUI.visible = true

func _on_Tamagotchi_switch_to_sick() -> void:
	$SickHappinessUI.visible = true
	$PetHappinessUI.visible = false
