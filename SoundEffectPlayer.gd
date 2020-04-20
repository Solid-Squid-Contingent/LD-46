extends AudioStreamPlayer

var sfxDict = {
	"doorbell" : preload("res://Resources/Sounds/doorbell.wav"),
	"static" : preload("res://Resources/Sounds/static.wav"),
	"watersplash" : preload("res://Resources/Sounds/doorbell.wav"),
	"whale" : preload("res://Resources/Sounds/whale.wav")
}

func _ready():
	pass


func _on_DialogManager_play_sound_effect(name):
	stop()
	set_stream(sfxDict[name])
	play()
