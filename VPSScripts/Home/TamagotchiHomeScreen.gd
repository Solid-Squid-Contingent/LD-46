extends Node2D

signal switch_to_pet
signal switch_to_sick

var currentIdleAnimation = "idle"

export(float) var animationLength = 2

onready var animationTimer = $AnimationTimer

onready var allSprites = [
	$BabySprite,
	$AdultSprite,
	$OldSprite]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_animating() -> bool:
	return not animationTimer.is_stopped()

func _on_Screen_eat():
	for sprite in allSprites:
		sprite.animation = "eat"
	animationTimer.start(animationLength)

func _on_Screen_start_sleeping():
	for sprite in allSprites:
		sprite.animation = "sleep"
	animationTimer.stop()

func _on_Screen_end_sleeping():
	for sprite in allSprites:
		sprite.animation = currentIdleAnimation

func _on_Screen_happy():
	for sprite in allSprites:
		sprite.animation = "happy"
		animationTimer.start(animationLength)

func _on_Screen_refuse():
	for sprite in allSprites:
		sprite.animation = "refuse"
		animationTimer.start(animationLength)

func _on_Screen_sad():
	currentIdleAnimation = "sad"
	for sprite in allSprites:
		sprite.animation = currentIdleAnimation

func _on_AnimationTimer_timeout():
	for sprite in allSprites:
		sprite.animation = currentIdleAnimation

func _on_Screen_end_talking():
	for sprite in allSprites:
		sprite.animation = currentIdleAnimation

func _on_Screen_start_talking():
	for sprite in allSprites:
		sprite.animation = "talk"

func _on_Screen_not_sad():
	currentIdleAnimation = "idle"


func _on_Screen_switch_to_pet():
	pass # Replace with function body.


func _on_Screen_switch_to_sick():
	pass # Replace with function body.
