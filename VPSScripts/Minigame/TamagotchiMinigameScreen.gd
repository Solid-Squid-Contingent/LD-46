extends Container

var timePassed : float = 5
var enemyScene = preload("res://VPSScenes/Minigame/Enemy.tscn")
var bulletScene = preload("res://VPSScenes/Minigame/Bullet.tscn")

export (int) var minX = 10
export (int) var maxX = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.set_paused(true)

func spawnEnemy():
	var enemy = enemyScene.instance()
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
			return
			
	print("You died")


func _on_EnemySpawnTimer_timeout():
	spawnEnemy()
