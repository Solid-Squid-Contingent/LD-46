extends Node2D
signal new_chapter(number, subtitle)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func game_over():
	show_screen($GameOverScreen)

func show_new_chapter(number, subtitle):
	emit_signal("new_chapter", number, subtitle)
	show_screen($ChapterScreen)

func show_screen(screen):
	get_tree().paused = true
	screen.popup()

func hide_screen(screen):
	get_tree().paused = false
	screen.go_away()

func restart_game():
	get_tree().reload_current_scene()
	get_tree().paused = false

func quit_game():
	get_tree().quit()

func continue_game():
	hide_screen($MenuScreen)

func _input(event):
	if event.is_action_pressed("menu"):
		show_screen($MenuScreen)

func _on_Tamagotchi_tamagotchi_died():
	game_over()

func _on_GameOverScreen_QuitButton_pressed():
	quit_game()

func _on_GameOverScreen_RestartButton_pressed():
	restart_game()

func _on_MenuScreen_QuitButton_pressed():
	quit_game()

func _on_MenuScreen_RestartButton_pressed():
	restart_game()

func _on_MenuScreen_OptionsButton_pressed():
	show_screen($OptionsScreen)

func _on_MenuScreen_ContinueButton_pressed():
	continue_game()

func _on_OptionsScreen_backButton_pressed():
	hide_screen($OptionsScreen)
	show_screen($MenuScreen)
