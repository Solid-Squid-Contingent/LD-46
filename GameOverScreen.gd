extends TextureRect

signal QuitButton_pressed()
signal RestartButton_pressed()


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func popup():
	visible = true
	$Timer.start()

func show_buttons():
	$ButtonContainer.visible = true

func _on_QuitButton_pressed():
	emit_signal("QuitButton_pressed")

func _on_RestartButton_pressed():
	emit_signal("RestartButton_pressed")

func _on_Timer_timeout():
	show_buttons()

func _on_GameOverScreen_gui_input(event):
	show_buttons()
