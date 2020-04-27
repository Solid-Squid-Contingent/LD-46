extends TextureRect

signal backButton_pressed()
signal loadButton_pressed(fileName)
signal button_pressed()

onready var savesList = $VBoxContainer/ListContainer/ItemList
const Util = preload("res://SaveFileUtils.gd")

func _ready():
	visible = false

func popup():
	visible = true
	Util.update_saves_list(savesList)

func go_away():
	visible = false


func _on_BackButton_pressed():
	emit_signal("backButton_pressed")
	emit_signal("button_pressed")


func _on_ItemList_item_activated(index):
	var fileName = savesList.get_item_text(index)
	emit_signal("loadButton_pressed", fileName)
	emit_signal("button_pressed")
