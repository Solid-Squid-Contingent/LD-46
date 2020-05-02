extends "res://VPSScripts/Minigame/EnemyBullet.gd"

var timePassed: float = 0

func _ready():
	timePassed = (randi() % 2) * PI

func move(delta):
	position.x -= sin(timePassed * velocity.length() / 15.0) * 10
	position += delta * velocity
	timePassed += delta
	position.x += sin(timePassed * velocity.length() / 15.0) * 10
