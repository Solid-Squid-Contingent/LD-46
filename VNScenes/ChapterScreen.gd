extends TextureRect

signal hide_screen
signal pause_music
signal unpause_music

func _ready():
	visible = false

func popup():
	visible = true
	$ChapterLabel.visible = false
	$Subtitle.visible = false
	$TitleAppearTimer.start()
	$SubtitleAppearTimer.start()
	emit_signal("pause_music")

func go_away():
	visible = false
	emit_signal("unpause_music")

func set_chapter(number):
	$ChapterLabel.bbcode_text = "[center]Chapter " + String(number)

func set_chapter_subtitle(title):
	$Subtitle.bbcode_text = "[center]" + title

func _on_Main_new_chapter(number, subtitle):
	set_chapter(number)
	set_chapter_subtitle(subtitle)


func _on_ChapterScreen_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if not $TitleAppearTimer.is_stopped():
			$TitleAppearTimer.stop()
			$ChapterLabel.visible = true
		elif not $SubtitleAppearTimer.is_stopped():
			$SubtitleAppearTimer.stop()
			$Subtitle.visible = true
		else:
			emit_signal("hide_screen")


func _on_TitleAppearTimer_timeout():
	$ChapterLabel.visible = true


func _on_SubtitleAppearTimer_timeout():
	$Subtitle.visible = true
