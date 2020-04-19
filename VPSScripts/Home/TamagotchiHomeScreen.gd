extends Node2D

signal eat
signal start_sleeping
signal end_sleeping
signal happy
signal refuse
signal sad

export(float) var animationLength = 2

onready var animationTimer = $AnimationTimer

onready var allSprites = [
	$BabySprite,
	$AdultSprite,
	$OldSprite]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Screen_eat():
	for sprite in allSprites:
		sprite.animation = "eat"
	animationTimer.start(animationLength)

func _on_Screen_start_sleeping():
	for sprite in allSprites:
		sprite.animation = "sleep"

func _on_Screen_end_sleeping():
	for sprite in allSprites:
		sprite.animation = "idle"

func _on_Screen_happy():
	for sprite in allSprites:
		sprite.animation = "happy"
		animationTimer.start(animationLength)

func _on_Screen_refuse():
	for sprite in allSprites:
		sprite.animation = "refuse"
		animationTimer.start(animationLength)

func _on_Screen_sad():
	for sprite in allSprites:
		sprite.animation = "sad"
		animationTimer.start(animationLength)

func _on_AnimationTimer_timeout():
	for sprite in allSprites:
		sprite.animation = "idle"
