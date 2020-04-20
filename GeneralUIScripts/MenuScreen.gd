extends TextureRect

signal QuitButton_pressed()
signal RestartButton_pressed()
signal OptionsButton_pressed()
signal ContinueButton_pressed()


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func popup():
	visible = true
	get_tree().paused = true

func go_away():
	visible = false

func _on_QuitButton_pressed():
	emit_signal("QuitButton_pressed")

func _on_RestartButton_pressed():
	emit_signal("RestartButton_pressed")

func _on_OptionsButton_pressed():
	emit_signal("OptionsButton_pressed")

func _on_ContinueButton_pressed():
	emit_signal("ContinueButton_pressed")
