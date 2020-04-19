extends TextureRect

signal backButton_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func popup():
	visible = true
	get_tree().paused = true

func go_away():
	visible = false


func _on_BackButton_pressed():
	emit_signal("backButton_pressed")
