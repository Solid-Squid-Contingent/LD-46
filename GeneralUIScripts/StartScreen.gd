extends TextureRect

signal hide_screen

func _ready():
	pass

func popup():
	visible = true

func go_away():
	visible = false

func _on_StartScreen_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("hide_screen")
