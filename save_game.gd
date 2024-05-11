extends Node
class_name SaveGame


func _ready():
	load_game()


func _process(delta):
	pass



static func save():
	var save_dict = {
		"score" : Global.player_task_level_points,
		"world" : Global.most_recent_scene,
		"player_pos" : Global.player_position
		#task_menu_first_task
	}
	return save_dict

static func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)


static func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		#print("LOAD GAME DATA: ", node_data)
		Global.player_task_level_points = node_data["score"]
		Global.most_recent_scene = node_data["world"]
		Global.player_inital_map_position = str_to_var("Vector2" + node_data["player_pos"])
