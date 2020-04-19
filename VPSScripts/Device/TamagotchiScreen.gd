extends Node2D
signal eat
signal start_sleeping
signal end_sleeping
signal happy
signal refuse
signal sad
signal start_talking
signal end_talking

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


func _on_Tamagotchi_eat():
	emit_signal("eat")


func _on_Tamagotchi_end_sleeping():
	emit_signal("end_sleeping")


func _on_Tamagotchi_happy():
	emit_signal("happy")


func _on_Tamagotchi_refuse():
	emit_signal("refuse")


func _on_Tamagotchi_sad():
	emit_signal("sad")


func _on_Tamagotchi_start_sleeping():
	emit_signal("start_sleeping")


func _on_Tamagotchi_start_talking():
	emit_signal("start_talking")


func _on_Tamagotchi_end_talking():
	emit_signal("end_talking")
