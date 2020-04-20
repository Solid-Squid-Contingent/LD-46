extends Area2D

func _ready():
	pass

func _on_OutOfBoundsArea_area_entered(area):
	area.queue_free()
