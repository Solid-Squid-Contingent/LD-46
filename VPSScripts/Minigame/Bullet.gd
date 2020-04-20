extends Area2D

var paused: bool = false

func _ready():
	pass


func _process(delta):
	if not paused:
		position.y += delta * 70

func pause():
	paused = true

func unpause():
	paused = false


func _on_Bullet_area_entered(area):
	queue_free()
