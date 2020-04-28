extends AudioStreamPlayer

func _ready():
	pass


func _on_GameOverScreen_button_pressed():
	play()

func _on_MenuScreen_button_pressed():
	play()

func _on_StartMenuScreen_button_pressed():
	play()

func _on_OptionsScreen_button_pressed():
	play()

func _on_StartScreen_hide_screen():
	play()

func _on_EndScreen_button_pressed():
	play()

func _on_DialogManager_button_pressed():
	play()
