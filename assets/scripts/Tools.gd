extends Node

func saveData():
	var data = 	{	
				"Player":
					{
					"Score":GLOBAL.max_score
					},
				"Options":
					{
					"Sound":GLOBAL.sound
					}
				}
	
	var SAVE_PATH = "user://data.json"
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_line(to_json(data))
	file.close()

func loadData():
	var LOAD_PATH = "user://data.json"
	var file = File.new()
	if !file.file_exists(LOAD_PATH):
		print("ERROR: No files found!")
		return -1
	file.open(LOAD_PATH, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	if data.has("Player"):
		GLOBAL.max_score = data["Player"]["Score"]
	if data.has("Options"):
		GLOBAL.sound = bool(data["Options"]["Sound"])


func exitGame():
	saveData()
	get_tree().quit()
