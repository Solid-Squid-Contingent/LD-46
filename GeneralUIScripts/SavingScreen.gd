extends TextureRect

signal backButton_pressed()
signal save(fileName)
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

func _on_LineEdit_text_entered(new_text):
	emit_signal("save", new_text)
	emit_signal("button_pressed")


func _on_ItemList_item_selected(index):
	savesList.unselect_all()
