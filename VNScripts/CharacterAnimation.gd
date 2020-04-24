extends Node2D

var animating: bool
var timePassed: float
var animationTime: float

export (float) var minFrameTime = 0.02
export (float) var maxFrameTime = 0.2

onready var sprite = $Sprite

func _ready():
	animating = false
	timePassed = 0
	
func _process(delta):
	if animating:
		timePassed += delta
		if timePassed > animationTime:
			timePassed -= animationTime
			sprite.set_frame(1 - sprite.get_frame())
			animationTime = rand_range(minFrameTime, maxFrameTime)


func set_sprite_frames(spriteFrames):
	sprite.set_sprite_frames(spriteFrames)
	
func start_animating():
	animating = true
	timePassed = 0
	animationTime = rand_range(minFrameTime, maxFrameTime)


func stop_animating():
	animating = false
	sprite.set_frame(0)
