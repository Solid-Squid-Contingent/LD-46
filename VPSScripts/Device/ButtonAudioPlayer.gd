extends AudioStreamPlayer

var buttonsSounds = [
	preload("res://Resources/Sounds/button1.wav"),
	preload("res://Resources/Sounds/button2.wav"),
	preload("res://Resources/Sounds/button3.wav"),
	preload("res://Resources/Sounds/button4.wav")
]

func _ready():
	pass


func _on_Tamagotchi_button_pressed():
	stop()
	set_stream(buttonsSounds[randi() % buttonsSounds.size()])
	play()
