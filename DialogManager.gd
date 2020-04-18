extends Node

export(String, FILE) var startFileName

var data
var dataPosition
var dialogChoices
var maxDataPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	loadFile(startFileName)
	
	printNextDialogLine()
	printNextDialogLine()
	printNextDialogLine()
	printNextDialogLine()
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


func printNextDialogLine():
	var currentData = data
	for i in range(dataPosition.size()):
		currentData = currentData["next"][dataPosition[i]]
		if i < dataPosition.size() -1:
			currentData = currentData["choices"][dialogChoices[i]]
		
	print(currentData["name"], ": ", currentData["text"])
	if currentData.has("choices"):
		var choice = 0 #TODO
		
		dialogChoices.push_back(choice)
		dataPosition.push_back(0)
		maxDataPosition.push_back(currentData["choices"][choice]["next"].size())
	else:
		while dataPosition.size() > 1 and \
		 	  dataPosition[dataPosition.size() - 1] + 1 >= maxDataPosition[dataPosition.size() - 1]:
			dataPosition.pop_back()
			maxDataPosition.pop_back()
			dialogChoices.pop_back()
			
		dataPosition[dataPosition.size() - 1] += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
