extends TextureRect

signal backButton_pressed()
signal save(fileName)
signal button_pressed()

onready var savesList = $VBoxContainer/ListContainer/ItemList
const Util = preload("res://SaveFileUtils.gd")

onready var popupPanel = $PopupPanel
onready var lineEdit = $VBoxContainer/MarginContainer/LineEdit

func _ready():
	visible = false

func popup():
	visible = true
	Util.update_saves_list(savesList)

func go_away():
	visible = false

func popup_saved_game():
	popupPanel.set_title("Saved!")
	popupPanel.set_text("Your current progress was saved. You can now savely quit the game without losing your progress.")
	popupPanel.hide_ok_button()
	popupPanel.hide_abort_button()
	popupPanel.hide_after_sec(3)
	
func popup_overwrite_warning():
	popupPanel.set_title("Overwrite?")
	popupPanel.set_text("If you proceed you'll overwrite this save. Are you really sure?")
	popupPanel.show_ok_button()
	popupPanel.show_abort_button()
	popupPanel.connect("ok_button_pressed", self, "ok_overwrite")
	popupPanel.connect("abort_button_pressed", self, "abort_overwrite")

func ok_overwrite():
	#TODO: actually save
	popupPanel.disconnect("ok_button_pressed", self, "ok_overwrite")
	popupPanel.disconnect("abort_button_pressed", self, "abort_overwrite")

func abort_overwrite():
	popupPanel.hide()
	popupPanel.disconnect("abort_button_pressed", self, "abort_overwrite")
	popupPanel.disconnect("ok_button_pressed", self, "ok_overwrite")

func save():
	if not lineEdit.text.is_valid_filename():
		return #TODO: Error Message
	emit_signal("save", lineEdit.text)

func change_save_name(newName):
	lineEdit.text = newName

func _on_BackButton_pressed():
	emit_signal("backButton_pressed")
	emit_signal("button_pressed")

# warning-ignore:unused_argument
func _on_LineEdit_text_entered(newText):
	save()
	emit_signal("button_pressed")

func _on_ItemList_item_selected(index):
	lineEdit.text = $VBoxContainer/ListContainer/ItemList.get_item_text(index)

func _on_SaveButton_pressed():
	save()
	emit_signal("button_pressed")
