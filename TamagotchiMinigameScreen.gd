extends Node2D

var timePassed : float = 5
var enemyScene = preload("res://MinigameEnemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
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
	pass
