extends Area2D

var paused: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not paused:
		position.y += delta * 50

func pause():
	paused = true

func unpause():
	paused = false
