extends Area2D

var paused: bool = false

var bulletScene = preload("res://VPSScenes/Minigame/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not paused:
		position.y -= delta * 2

func pause():
	paused = true
	$BulletTimer.set_paused(true)

func unpause():
	paused = false
	$BulletTimer.set_paused(false)

func shoot():
	for i in range(6):
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.velocity = Vector2(0, -15).rotated(int(i / 2) * 0.5)
		if i % 2:
			bullet.velocity.x = -bullet.velocity.x
		get_parent().add_child(bullet)


func _on_Area2D_area_entered(area):
	queue_free()


func _on_BulletTimer_timeout():
	shoot()
