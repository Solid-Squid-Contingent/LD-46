extends Node

export(int) var currentSaveVersion

func _ready():
	pass


func save_object(object):
	var savedData = {
		"filename" : object.get_filename()
	}
	
	for propertyName in object.savedProperties():
		savedData[propertyName] = object.get(propertyName)
	
	return savedData

func save_game(fileName):
	var saveFile = File.new()
	saveFile.open("user://saves/" + fileName + ".save", File.WRITE)
	saveFile.store_line(String(currentSaveVersion))
	var saveNodes = get_tree().get_nodes_in_group("Persistent")
	for node in saveNodes:
		var nodeData = save_object(node)
		saveFile.store_line(to_json(nodeData))
	saveFile.close()
	

func load_object(object, data):
	for propertyName in data:
		if propertyName != "filename":
			object.set(propertyName, data[propertyName])

func load_game(fileName):
	var saveFile = File.new()
	if not saveFile.file_exists("user://saves/" + fileName + ".save"):
		return # Error! We don't have a save to load. TODO

	saveFile.open("user://saves/" + fileName + ".save", File.READ)
	var savedSaveVersion = int(saveFile.get_line())
	if savedSaveVersion != currentSaveVersion:
		return # Error! Wrong version. TODO
		
	while not saveFile.eof_reached():
		var currentLine = saveFile.get_line()
		if currentLine.length() > 0:
			var currentData = parse_json(currentLine)
			
			var saveNodes = get_tree().get_nodes_in_group("Persistent")
			for node in saveNodes:
				if node.get_filename() == currentData["filename"]:
					load_object(node, currentData)
				
	saveFile.close()


func delete_save(fileName):
	var directory = Directory.new()
	directory.open("user://saves/")
	directory.remove(fileName + ".save")
