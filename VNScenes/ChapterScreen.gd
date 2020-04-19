extends TextureRect

func _ready():
	visible = false

func popup():
	visible = true

func go_away():
	visible = false

func set_chapter(number):
	$ChapterLabel.bbcode_text = "[center]Chapter " + String(number)

func set_chapter_subtitle(title):
	$Subtitle.bbcode_text = "[center]" + title

func _on_Main_new_chapter(number, subtitle):
	set_chapter(number)
	set_chapter_subtitle(subtitle)
