extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func game_over() -> void:
	get_tree().paused = true
	$GameOverScreen.popup_centered_ratio()

func restart_game() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false

func quit_game() -> void:
	get_tree().quit()

func _on_Tamagotchi_tamagotchi_died() -> void:
	game_over()

func _on_GameOverScreen_QuitButton_pressed():
	quit_game()

func _on_GameOverScreen_RestartButton_pressed():
	restart_game()
