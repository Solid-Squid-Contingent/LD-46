extends AudioStreamPlayer

func _ready():
	pass


func _on_DialogManager_advance_dialog():
	play()
