extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func popup():
	visible = true

func go_away():
	visible = false

func set_chapter(number):
	$ChapterLabel.bbcode_text = "[center]Chapter " + number

func set_cpater_subtitle(title):
	$Subtitle.bbcode_text = "[center]" + title

func _on_Main_new_chapter(number, subtitle):
	set_chapter(number)
	set_cpater_subtitle(subtitle)
