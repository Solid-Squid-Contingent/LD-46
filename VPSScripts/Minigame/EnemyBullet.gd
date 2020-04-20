extends Area2D

var paused: bool = false
var velocity: Vector2

func _ready():
	pass


func _process(delta):
	if not paused:
		position += delta * velocity

func pause():
	paused = true

func unpause():
	paused = false


func _on_EnemyBullet_area_entered(area):
	queue_free()
