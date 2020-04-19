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

func _on_Tamagotchi_tamagotchi_died():
	game_over()

func _on_GameOverScreen_QuitButton_pressed():
	quit_game()

func _on_GameOverScreen_RestartButton_pressed():
	restart_game()


func _on_DialogManager_new_chapter(number, subtitle):
	show_new_chapter(number, subtitle)

func _on_ChapterScreen_hide_screen():
	hide_screen($ChapterScreen)
