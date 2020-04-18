extends Node

signal reduce_fullness(amount)
signal reduce_awakeness(amount)
signal reduce_fun(amount)
signal reduce_happiness(amount)
signal reduce_everything(amount)

export(String, FILE) var startFileName

var choiceButtonScene = preload("res://ChoiceButton.tscn")
onready var vnTextBox = get_node("/root/Main/VNTextBox")
onready var choiceButtonContainer = get_node("/root/Main/CharacterView/ChoiceButtonContainer")

var data
var dataPosition
var dialogChoices
var maxDataPosition
var inChoice : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_file(startFileName)
	print_next_dialog_line()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and not inChoice:
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
	var currentData = get_current_dialog_data()
		
	vnTextBox.set_label(currentData["name"] + ": " + currentData["text"])
	execute_side_effects(currentData)
	
	if currentData.has("choices"):
		for i in range(currentData["choices"].size()):
			var button = choiceButtonScene.instance()
			button.set_label(currentData["choices"][i]["text"]) 
			button.connect("pressed", self, "_on_ChoiceButtonPressed", [i])
			choiceButtonContainer.add_child(button)
		
		inChoice = true
	else:
		while dataPosition.size() > 1 and \
		 	  dataPosition[dataPosition.size() - 1] + 1 >= maxDataPosition[dataPosition.size() - 1]:
			dataPosition.pop_back()
			maxDataPosition.pop_back()
			dialogChoices.pop_back()
			
		dataPosition[dataPosition.size() - 1] += 1


func execute_side_effects(currentData):
	for need in ["reduce_fullness", "reduce_awakeness", "reduce_fun", "reduce_happiness", "reduce_everything"]:
		if currentData.has(need):
			emit_signal(need, currentData[need])


func _on_ChoiceButtonPressed(choice):
	var currentData = get_current_dialog_data()
	
	dialogChoices.push_back(choice)
	dataPosition.push_back(0)
	maxDataPosition.push_back(currentData["choices"][choice]["next"].size())
	
	for child in choiceButtonContainer.get_children():
		child.queue_free()
	
	inChoice = false
	
	print_next_dialog_line()
