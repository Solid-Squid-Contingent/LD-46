extends TextureRect

signal hide_screen

func _ready():
	pass

func popup():
	visible = true
	$EatingSquid.visible = true
	$Credits.visible = false


func _on_EndScreen_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if $EatingSquid.visible:
			$EatingSquid.visible = false
			$Credits.visible = true
		else:
			emit_signal("hide_screen")
