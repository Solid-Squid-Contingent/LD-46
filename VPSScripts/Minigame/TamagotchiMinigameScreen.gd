extends Container

signal game_over

var timePassed : float = 5
var enemyScenes = [
	preload("res://VPSScenes/Minigame/EnemyFan.tscn"),
	preload("res://VPSScenes/Minigame/EnemyTargeted.tscn"),
	preload("res://VPSScenes/Minigame/EnemySine.tscn"),
	preload("res://VPSScenes/Minigame/EnemySpawning.tscn")
]

var bulletScene = preload("res://VPSScenes/Minigame/Bullet.tscn")

export (int) var minX = 5
export (int) var maxX = 65

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.set_paused(true)
	randomize()

func spawnEnemy():
	var enemy = enemyScenes[randi() % enemyScenes.size()].instance()
	enemy.position = $EnemySpawnPosition1.position.linear_interpolate($EnemySpawnPosition2.position, randf())
	add_child(enemy)


func moveLeft():
	$Player.position.x -= 5
	if $Player.position.x < minX:
		$Player.position.x += 5

func moveRight():
	$Player.position.x += 5
	if $Player.position.x > maxX:
		$Player.position.x -= 5
	

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = $Player.position
	add_child(bullet)

func pause():
	$EnemySpawnTimer.set_paused(true)

func unpause():
	$EnemySpawnTimer.set_paused(false)


func _on_Player_area_entered(area):
	for heart in $HeartContainer.get_children():
		if heart.visible:
			heart.visible = false
			break
	
	for heart in $HeartContainer.get_children():
		if heart.visible:
			return
			
	emit_signal("game_over")


func _on_EnemySpawnTimer_timeout():
	spawnEnemy()
