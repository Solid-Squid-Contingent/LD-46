extends TextureRect

signal backButton_pressed
signal toggle_fullscreen(toggle_state)
signal change_resolution(new_resolution)
signal change_music_volume(new_volume)
signal change_soundeffects_volume(new_volume)
signal button_pressed()

var resolutions = [
	Vector2(960, 540),
	Vector2(1200, 675),
	Vector2(1440, 810),
	Vector2(1920, 1080),
	Vector2(3840, 2160)
]
onready var resolutionButton = $VBoxContainer/SettingsContainer/GridContainer/ResolutionButton

onready var start_resolution = get_node("/root/Main").start_resolution

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	set_resolution_options()
	initialze_resolution_setting()

func initialze_resolution_setting():
	resolutionButton.select(start_resolution)
	emit_signal("change_resolution", resolutions[start_resolution])

func popup():
	visible = true
	get_tree().paused = true

func go_away():
	visible = false

func set_resolution_options():
	for resolutionIndex in range(resolutions.size()):
		var resolution_text = String(resolutions[resolutionIndex].x) + " x " + String(resolutions[resolutionIndex].y)
		resolutionButton.add_item(resolution_text, resolutionIndex)

func _on_BackButton_pressed():
	emit_signal("backButton_pressed")
	emit_signal("button_pressed")

func _on_FullscreenToggle_toggled(button_pressed):
	emit_signal("toggle_fullscreen", button_pressed)
	emit_signal("button_pressed")

func _on_ResolutionButton_item_selected(id):
	emit_signal("change_resolution", resolutions[id])
	emit_signal("button_pressed")

func _on_MusicSlider_value_changed(value):
	emit_signal("change_music_volume", value)


func _on_SoundeffectsSlider_value_changed(value):
	emit_signal("change_soundeffects_volume", value)
