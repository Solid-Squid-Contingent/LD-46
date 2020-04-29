extends "res://VPSScripts/Minigame/EnemyBullet.gd"

var bulletScene = preload("res://VPSScenes/Minigame/EnemyBullet.tscn")

func _on_MoreBulletsTimer_timeout():
	for i in range(5):
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.velocity = velocity.rotated((i * 2 + 1) * 2 * PI / 10)
		get_parent().add_child(bullet)
