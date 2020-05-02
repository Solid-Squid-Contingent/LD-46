extends Area2D

var paused: bool = false
var velocity: Vector2

func _ready():
	pass


func _process(delta):
	if not paused:
		move(delta)

func set_velocity(newVelocity):
	velocity = newVelocity

func move(delta):
	position += delta * velocity

func pause():
	paused = true

func unpause():
	paused = false


# warning-ignore:unused_argument
func _on_EnemyBullet_area_entered(area):
	queue_free()
