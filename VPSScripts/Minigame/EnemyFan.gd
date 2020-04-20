extends "res://VPSScripts/Minigame/Enemy.gd"

func shoot():
	for i in range(1,6):
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.velocity = Vector2(0, -15).rotated(int(i / 2) * 0.5)
		if i % 2:
			bullet.velocity.x = -bullet.velocity.x
		get_parent().add_child(bullet)
