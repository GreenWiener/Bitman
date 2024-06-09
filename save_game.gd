extends Node
class_name SaveGame

static func save(): # muutujate salvestamine
	var save_dict = {
		"score" : Global.player_task_level_points,
		"world" : Global.most_recent_scene,
		"player_pos" : Global.player_position
	}
	return save_dict

static func save_game(): # salvestatava info kirjutamine faili
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

static func load_game(): # salvestatud info lugemine failist
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var load_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	print(load_file.get_path())
	
	while load_file.get_position() < load_file.get_length():
		var json_string = load_file.get_line()
		var json = JSON.new()
		var _parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		#print("LOAD GAME DATA: ", node_data)
		# muutujatele failist loetud väärtusete omistamine
		Global.player_task_level_points = node_data["score"]
		Global.most_recent_scene = node_data["world"]
		Global.player_inital_map_position = str_to_var("Vector2" + node_data["player_pos"])
