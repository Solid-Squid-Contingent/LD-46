extends Node

export(String, FILE) var startFileName

var choiceButtonScene = preload("res://ChoiceButton.tscn")

var data
var dataPosition
var dialogChoices
var maxDataPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	loadFile(startFileName)
	
	printNextDialogLine()
	printNextDialogLine()


func loadFile(fileName):
	var data_file = File.new()
	if data_file.open(fileName, File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
		
	data = {"next" : data_parse.result}
	dataPosition = [0]
	dialogChoices = []
	maxDataPosition = [data["next"].size()]


func getCurrentDialogData():
	var currentData = data
	for i in range(dataPosition.size()):
		currentData = currentData["next"][dataPosition[i]]
		if i < dataPosition.size() -1:
			currentData = currentData["choices"][dialogChoices[i]]
	return currentData


func printNextDialogLine():
	var currentData = getCurrentDialogData()
		
	print(currentData["name"], ": ", currentData["text"])
	if currentData.has("choices"):
		for i in range(currentData["choices"].size()):
			var button = choiceButtonScene.instance()
			button.setLabel(currentData["choices"][i]["text"]) 
			button.connect("pressed", self, "_on_ChoiceButtonPressed", [i])
			get_node("/root/Main/CharacterView/ChoiceButtonContainer").add_child(button)
	else:
		while dataPosition.size() > 1 and \
		 	  dataPosition[dataPosition.size() - 1] + 1 >= maxDataPosition[dataPosition.size() - 1]:
			dataPosition.pop_back()
			maxDataPosition.pop_back()
			dialogChoices.pop_back()
			
		dataPosition[dataPosition.size() - 1] += 1


func _on_ChoiceButtonPressed(choice):
	var currentData = getCurrentDialogData()
	
	dialogChoices.push_back(choice)
	dataPosition.push_back(0)
	maxDataPosition.push_back(currentData["choices"][choice]["next"].size())
	
	printNextDialogLine()
