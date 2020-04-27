static func update_saves_list(savesList):
	savesList.clear()
	
	var dir = Directory.new()
	if not dir.dir_exists("user://saves/"):
		dir.make_dir("user://saves/")
		
	if dir.open("user://saves/") == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				savesList.add_item(fileName.left(fileName.length() - 5))
			fileName = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
