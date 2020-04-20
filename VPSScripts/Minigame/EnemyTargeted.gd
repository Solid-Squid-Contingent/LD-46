extends "res://VPSScripts/Minigame/Enemy.gd"

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = position
	bullet.velocity = get_parent().get_node("Player").position - position
	get_parent().add_child(bullet)
