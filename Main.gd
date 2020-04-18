extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func game_over():
	get_tree().paused = true
	$GameOverScreen.popup()

func restart_game():
	get_tree().reload_current_scene()
	get_tree().paused = false

func quit_game():
	get_tree().quit()

func _on_Tamagotchi_tamagotchi_died():
	game_over()

func _on_GameOverScreen_QuitButton_pressed():
	quit_game()

func _on_GameOverScreen_RestartButton_pressed():
	restart_game()
