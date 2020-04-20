extends Node2D

signal all_text_appeared

onready var label = $TextBox/Label
onready var nameLabel = $TextBox/NameLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	show_all_text()


func set_text(text):
	label.bbcode_text = text
	label.set_visible_characters(0)
	$ShowTextTimer.start()

func set_name(name):
	if name.length() == 0:
		nameLabel.bbcode_text = ""
	else:
		nameLabel.bbcode_text = "[b]" + name + ":[/b]"


func all_text_appeared():
	return label.get_visible_characters() >= label.get_total_character_count()

func show_all_text():
	label.set_visible_characters(label.get_total_character_count())

func _on_ShowTextTimer_timeout():
	label.set_visible_characters(label.get_visible_characters() + 1)
	if not all_text_appeared():
		$ShowTextTimer.start()
	else:
		emit_signal("all_text_appeared")
