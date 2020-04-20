extends Area2D

var paused: bool = false

var bulletScene = preload("res://VPSScenes/Minigame/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not paused:
		position.y -= delta * 10

func pause():
	paused = true

func unpause():
	paused = false

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = position
	get_parent().add_child(bullet)


func _on_Area2D_area_entered(area):
	queue_free()


func _on_BulletTimer_timeout():
	shoot()
