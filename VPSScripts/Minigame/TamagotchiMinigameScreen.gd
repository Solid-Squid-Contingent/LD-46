extends Container

signal game_over

const enemyScenes = [
	preload("res://VPSScenes/Minigame/EnemyFan.tscn"),
	preload("res://VPSScenes/Minigame/EnemyTargeted.tscn"),
	preload("res://VPSScenes/Minigame/EnemySine.tscn"),
	preload("res://VPSScenes/Minigame/EnemySpawning.tscn")
]

const bulletScene = preload("res://VPSScenes/Minigame/Bullet.tscn")
onready var timer = $EnemySpawnTimer

export (int) var minX = 5
export (int) var maxX = 65
var enemySpeed = 2.0
var enemyBulletSpeed = 15.0
var enemyBulletTime = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.set_paused(true)

func _input(event):
	if event.is_action_pressed("ui_left"):
		move_left()
	elif event.is_action_pressed("ui_right"):
		move_right()
	elif event.is_action_pressed("ui_up"):
		shoot()
		

func spawn_enemy():
	var enemy = enemyScenes[randi() % enemyScenes.size()].instance()
	enemy.position = $EnemySpawnPosition1.position.linear_interpolate($EnemySpawnPosition2.position, randf())
	enemy.position.x -= fmod(enemy.position.x, 5.0)
	add_child(enemy)
	enemy.set_speed(enemySpeed)
	enemy.set_bullet_time(enemyBulletTime)
	enemy.set_bullet_speed(enemyBulletSpeed)


func move_left():
	$Player.position.x -= 5
	if $Player.position.x < minX:
		$Player.position.x += 5

func move_right():
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
	
func increase_difficulty():
	var thingToIncrease = randi() % 4
	if thingToIncrease == 0:
		timer.set_wait_time(timer.get_wait_time() / 1.5)
	elif thingToIncrease == 1:
		enemySpeed += 0.5
	elif thingToIncrease == 2:
		enemyBulletSpeed += 2.0
	elif thingToIncrease == 3:
		enemyBulletTime /= 1.5


# warning-ignore:unused_argument
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
	spawn_enemy()


func _on_DifficultyIncreaseTimer_timeout():
	increase_difficulty()
