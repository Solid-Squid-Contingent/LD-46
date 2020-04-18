extends TextureRect

signal QuitButton_pressed()
signal RestartButton_pressed()




# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func popup():
	visible = true

func _on_QuitButton_pressed():
	emit_signal("QuitButton_pressed")


func _on_RestartButton_pressed():
	emit_signal("RestartButton_pressed")


func _on_GameOverScreen_QuitButton_pressed():
	pass # Replace with function body.
