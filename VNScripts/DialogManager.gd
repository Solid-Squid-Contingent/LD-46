extends Node

signal reduce_fullness(amount)
signal reduce_awakeness(amount)
signal reduce_fun(amount)
signal reduce_happiness(amount)
signal reduce_everything(amount)

signal play_music(name)
signal play_sound_effect(name)

signal change_characters(characters)
signal change_background(background)

signal turn_tamagotchi_on
signal turn_tamagotchi_off
signal change_squid_stage(newStageName)

signal new_chapter(number, subtitle)

signal advance_dialog
signal game_ended

export(String, FILE) var startFileName

var choiceButtonScene = preload("res://VNScenes/ChoiceButton.tscn")
onready var vnTextBox = get_node("/root/Main/VNTextBox")
onready var tamagotchiTextBox = get_node("/root/Main/TamagotchiTextBox")
onready var choiceButtonContainer = get_node("/root/Main/CharacterView/ChoiceButtonContainer")

var data
var dataPosition
var dialogChoices
var maxDataPosition
var inChoice : bool = false
var require_eating : bool = false

var currentChapter : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	load_file(startFileName)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if not vnTextBox.all_text_appeared():
			vnTextBox.show_all_text()
		elif not tamagotchiTextBox.all_text_appeared():
			tamagotchiTextBox.show_all_text()
		elif not inChoice and not require_eating:
			print_next_dialog_line()


func load_file(fileName):
	var data_file = File.new()
	if data_file.open(fileName, File.READ) != OK:
		print("File could not be read.")
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("File could not be parsed as JSON.")
		print("Line ", data_parse.get_error_line(), ": ", data_parse.get_error_string())
		return
		
	data = {"next" : data_parse.result}
	dataPosition = [0]
	dialogChoices = []
	maxDataPosition = [data["next"].size()]


func get_current_dialog_data():
	var currentData = data
	for i in range(dataPosition.size()):
		currentData = currentData["next"][dataPosition[i]]
		if i < dataPosition.size() - 1:
			currentData = currentData["choices"][dialogChoices[i]]
	return currentData


func print_next_dialog_line():
	if dataPosition.size() == 0:
		emit_signal("game_ended")
		return
		
	emit_signal("advance_dialog")
	
	var currentData = get_current_dialog_data()
	
	if currentData.has("name") and currentData["name"] == "Squid":
		tamagotchiTextBox.set_text(currentData["text"])
	else:
		if currentData.has("name"):
			vnTextBox.set_name(currentData["name"])
		vnTextBox.set_text(currentData["text"])
	
	execute_side_effects(currentData)
	
	if currentData.has("choices"):
		inChoice = true
	else:
		while dataPosition.size() > 0 and dataPosition[dataPosition.size() - 1] + 1 >= maxDataPosition[dataPosition.size() - 1]:
			dataPosition.pop_back()
			maxDataPosition.pop_back()
			dialogChoices.pop_back()
		
		if dataPosition.size() > 0:
			dataPosition[dataPosition.size() - 1] += 1
	
	if currentData["text"].length() == 0:
		print_next_dialog_line()


func execute_side_effects(currentData):
	if currentData.has("new_chapter"):
		emit_signal("new_chapter", currentChapter, currentData["new_chapter"])
		currentChapter += 1
		
	for need in ["reduce_fullness", "reduce_awakeness", "reduce_fun", "reduce_happiness", "reduce_everything"]:
		if currentData.has(need):
			emit_signal(need, currentData[need])
	
	if currentData.has("music"):
		emit_signal("play_music", currentData["music"])
	
	if currentData.has("sfx"):
		emit_signal("play_sound_effect", currentData["sfx"])
	
	if currentData.has("characters"):
		emit_signal("change_characters", currentData["characters"])
	
	if currentData.has("background"):
		emit_signal("change_background", currentData["background"])
	
	if currentData.has("tamagotchi_on"):
		if currentData["tamagotchi_on"]:
			emit_signal("turn_tamagotchi_on")
		else:
			emit_signal("turn_tamagotchi_off")
	
	if currentData.has("squid_stage"):
		emit_signal("change_squid_stage", currentData["squid_stage"])
	
	if currentData.has("require_eating"):
		require_eating = true

func spawn_choice_buttons():
	var currentData = get_current_dialog_data()
	for i in range(currentData["choices"].size()):
		var button = choiceButtonScene.instance()
		button.set_label(currentData["choices"][i]["text"]) 
		button.connect("pressed", self, "_on_ChoiceButtonPressed", [i])
		choiceButtonContainer.add_child(button)


func _on_ChoiceButtonPressed(choice):
	var currentData = get_current_dialog_data()
	
	dialogChoices.push_back(choice)
	dataPosition.push_back(0)
	maxDataPosition.push_back(currentData["choices"][choice]["next"].size())
	
	for child in choiceButtonContainer.get_children():
		child.queue_free()
	
	inChoice = false
	
	print_next_dialog_line()


func _on_VNTextBox_all_text_appeared():
	if inChoice:
		spawn_choice_buttons()


func _on_Tamagotchi_eat():
	if require_eating and vnTextBox.all_text_appeared() and tamagotchiTextBox.all_text_appeared():
		require_eating = false
		print_next_dialog_line()


func _on_TamagotchiTextBox_all_text_appeared():
	if inChoice:
		spawn_choice_buttons()
