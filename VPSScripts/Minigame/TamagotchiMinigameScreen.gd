extends Node2D

var timePassed : float = 5
var enemyScene = preload("res://VPSScenes/Minigame/MinigameEnemy.tscn")
var bulletScene = preload("res://VPSScenes/Minigame/Bullet.tscn")
var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if not paused:
		timePassed += delta
		if timePassed > 5:
			timePassed -= 5
			spawnEnemy()

func spawnEnemy():
	var enemy = enemyScene.instance()
	$EnemySpawnPath/EnemySpawnLocation.unit_offset = randf()
	enemy.position = $EnemySpawnPath/EnemySpawnLocation.position
	add_child(enemy)


func moveLeft():
	$Player.position.x -= 10

func moveRight():
	$Player.position.x += 10

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = $Player.position
	add_child(bullet)

func pause():
	paused = true

func unpause():
	paused = false


func _on_Player_area_entered(area):
	for heart in $HeartContainer.get_children():
		if heart.visible:
			heart.visible = false
			return
			
	print("You died")
