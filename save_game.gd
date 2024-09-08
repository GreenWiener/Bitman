extends Node
class_name SaveGame

static func save_game_data(): # muutujate salvestamine
	var save_dict = {
		
		# player
		"score" : Global.player_task_level_points,
		"world" : Global.most_recent_scene,
		"player_pos" : Global.player_position,
		"train_pos" : Global.train_pos,
		"train_direction" : Global.train_direction,
		"next_train_direction" : Global.next_train_direction,
		
		
		"showed_helparrow" : Global.showed_helparrow,
		
		# holding item
		"item_name" : Global.item_name,
		"box_item" : Global.box_item,
		"player_holding_item" : Global.player_holding_item,
		
		# items
		
		"MOBO_item_ids" : Global.MOBO_item_id_list,
		"MOBO_item_names" : Global.MOBO_item_name_list,
		"MOBO_item_poses" : Global.MOBO_item_position_list,
		"MOBO_box_items" : Global.MOBO_box_item_list,

		"CPU_item_ids" : Global.CPU_item_id_list,
		"CPU_item_names" : Global.CPU_item_name_list,
		"CPU_item_poses" : Global.CPU_item_position_list,
		"CPU_box_items" : Global.CPU_box_item_list,

		"SSD_item_ids" : Global.SSD_item_id_list,
		"SSD_item_names" : Global.SSD_item_name_list,
		"SSD_item_poses" : Global.SSD_item_position_list,
		"SSD_box_items" : Global.SSD_box_item_list,

		"RAM_item_ids" : Global.RAM_item_id_list,
		"RAM_item_names" : Global.RAM_item_name_list,
		"RAM_item_poses" : Global.RAM_item_position_list,
		"RAM_box_items" : Global.RAM_box_item_list,
		
		"spawn_scene_items" : [Global.spawn_mobo_item, Global.spawn_ssd_item, Global.spawn_ram_item, Global.spawn_cpu_item], #pole eriti vaja tegelt
		"ram_locker_states" : Global.locker_state_dict2,
		
		# tasks
		"task_ongoing" : Global.task_ongoing,
		"tasks_pooleli" : [Global.task_ssd_pooleli, Global.task_ram_pooleli, Global.task_cpu_pooleli],
		"task_menu_info_dict": Global.task_menu_info_dict,
		"task_bin_num" : Global.task_bin_num,
		"subtask" : Global.subtask,
		"deliver_ram_item" : Global.deliver_ram_item,
		"deliver_cpu_item" : Global.deliver_cpu_item,
		"delivered_ram_items" : Global.delivered_ram_items,
		"delivered_cpu_items" : Global.delivered_cpu_items,
		
		"create_first_task" : Global.task_menu_first_task,
		"locker_num_list" : Global.locker_num_list,
		"locker_dict_keys" : Global.locker_dict_keys,
		"bin_task_completed_last" : Global.bin_task_completed_last,
		"locker_info_dict" : Global.locker_info_dict
	}
	return save_dict

static func save_settings_data():
	var save_dict = {
		
		"music_volume" : Global.music_volume,
		"fx_volume" : Global.fx_volume,
		"language" : Global.language
	}
	return save_dict




static func save_game(): # mängija ja mängu info salvestamine
	save_to_file(save_game_data(), "user://savegame.save")
	save_settings()

static func save_settings(): # mängu seadete salvestamine
	save_to_file(save_settings_data(), "user://settings.save")

static func load_game():
	load_from_file("user://savegame.save")

static func load_settings():
	load_from_file("user://settings.save")




static func save_to_file(data : Dictionary, file_path : String): # salvestatava info kirjutamine faili
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)
	print("🔄 <save_game> SAVING TO FILE: '", file_path, "', DATA: ", json_string)


static func load_from_file(file_path : String): # salvestatud info lugemine failist
	if not FileAccess.file_exists(file_path):
		print("❌ <save_game> file '", file_path, "' doesnt exist ❌")
		return
	print("✳ <save_game> loading data from file '", file_path, "' ✳")
	var load_file = FileAccess.open(file_path, FileAccess.READ)
	
	
	while load_file.get_position() < load_file.get_length():
		var json_string = load_file.get_line()
		var json = JSON.new()
		var _parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		print("🔄 <save_game> LOADED DATA: ", node_data)
		
		## muutujatele failist loetud väärtusete omistamine
		if file_path == "user://savegame.save":
			#player
			Global.player_task_level_points = node_data["score"]
			Global.most_recent_scene = node_data["world"]
			Global.player_inital_map_position = str_to_var("Vector2" + node_data["player_pos"])
			Global.train_pos = str_to_var("Vector2" + node_data["train_pos"])
			Global.train_direction =  node_data["train_direction"]
			Global.next_train_direction = node_data["next_train_direction"]
			print("<save_game> music_volume: ", Global.music_volume)
			Global.showed_helparrow = node_data["showed_helparrow"]
			
			# holding item
			Global.item_name = node_data["item_name"]
			Global.box_item = node_data["box_item"]
			Global.player_holding_item = node_data["player_holding_item"]
			
			# items
			Global.MOBO_item_id_list = node_data["MOBO_item_ids"]
			Global.MOBO_item_name_list = node_data["MOBO_item_names"]
			Global.MOBO_item_position_list = node_data["MOBO_item_poses"]
			Global.MOBO_box_item_list = node_data["MOBO_box_items"]

			Global.CPU_item_id_list = node_data["CPU_item_ids"]
			Global.CPU_item_name_list = node_data["CPU_item_names"]
			Global.CPU_item_position_list = node_data["CPU_item_poses"]
			Global.CPU_box_item_list = node_data["CPU_box_items"]

			Global.SSD_item_id_list = node_data["SSD_item_ids"]
			Global.SSD_item_name_list = node_data["SSD_item_names"]
			Global.SSD_item_position_list = node_data["SSD_item_poses"]
			Global.SSD_box_item_list = node_data["SSD_box_items"]

			Global.RAM_item_id_list = node_data["RAM_item_ids"]
			Global.RAM_item_name_list = node_data["RAM_item_names"]
			Global.RAM_item_position_list = node_data["RAM_item_poses"]
			Global.RAM_box_item_list = node_data["RAM_box_items"]
			
			#"spawn_scene_items" : [Global.spawn_mobo_item, Global.spawn_ssd_item, Global.spawn_ram_item, Global.spawn_cpu_item]
			Global.spawn_mobo_item = node_data["spawn_scene_items"][0]
			Global.spawn_ssd_item = node_data["spawn_scene_items"][1]
			Global.spawn_ram_item = node_data["spawn_scene_items"][2]
			Global.spawn_cpu_item = node_data["spawn_scene_items"][3]
			
			# tasks
			Global.task_ongoing = node_data["task_ongoing"]
			Global.task_ssd_pooleli = node_data["tasks_pooleli"][0]
			Global.task_ram_pooleli = node_data["tasks_pooleli"][1]
			Global.task_cpu_pooleli = node_data["tasks_pooleli"][2]
			Global.task_menu_info_dict = node_data["task_menu_info_dict"]
			Global.task_bin_num = node_data["task_bin_num"]
			Global.subtask = node_data["subtask"]
			Global.deliver_ram_item = node_data["deliver_ram_item"]
			Global.deliver_cpu_item = node_data["deliver_cpu_item"]
			Global.delivered_ram_items = node_data["delivered_ram_items"]
			Global.delivered_cpu_items = node_data["delivered_cpu_items"]
			
			Global.task_menu_first_task = node_data["create_first_task"]
			
			Global.locker_num_list = node_data["locker_num_list"]
			
			
			# --
			Global.locker_state_dict2 = node_data["ram_locker_states"]
			var temp_lstate_dict = {}
			for el in Global.locker_state_dict2:
				var tempkeycontent = Global.locker_state_dict2[el]
				var vec2key = string_to_vector2(el)
				temp_lstate_dict[vec2key] = tempkeycontent
				print("ELLELELELE: ", temp_lstate_dict)
			Global.locker_state_dict2 = temp_lstate_dict
			# --
			
			Global.locker_dict_keys = node_data["locker_dict_keys"]
			
			var temp_array2 = []
			for el in Global.locker_dict_keys:
				temp_array2.append(string_to_vector2(el))
			Global.locker_dict_keys = temp_array2
			#
			
			# järjendis olevate stringide vektoriteks teisendamine
			var temp_array = []
			var item_position_lists = [Global.MOBO_item_position_list, Global.CPU_item_position_list, Global.SSD_item_position_list, Global.RAM_item_position_list]
			
			var array_index = 0
			for list in item_position_lists:
				for el in list:
					#print("--- ", el, " to ", string_to_vector2(el))
					temp_array.append(string_to_vector2(el))
				item_position_lists[array_index] = temp_array
				temp_array = []
				#print("list: ", item_position_lists[array_index])
				array_index += 1
			
			Global.MOBO_item_position_list = item_position_lists[0]
			Global.CPU_item_position_list = item_position_lists[1]
			Global.SSD_item_position_list = item_position_lists[2]
			Global.RAM_item_position_list = item_position_lists[3]
		
		if file_path == "user://settings.save":
			Global.music_volume = node_data["music_volume"]
			Global.fx_volume = node_data["fx_volume"]
			Global.language = node_data["language"]
	
		#print("MOBO_list: ", Global.MOBO_item_position_list)
		#print("CPU_list: ", Global.CPU_item_position_list)
		#print("SSD_list: ", Global.SSD_item_position_list)
		#print("RAM_list: ", Global.RAM_item_position_list)

static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(float(array[0]), float(array[1]))

	return Vector2.ZERO


static func delete_save():
	DirAccess.remove_absolute("user://savegame.save")
	
	Global.player_task_level_points = 0
	Global.most_recent_scene = null
	Global.player_inital_map_position = Vector2(-772, 80)
	Global.train_pos = Vector2(-87, 41.725)
	Global.train_direction = true
	Global.next_train_direction = false
	Global.music_volume = 0.0
	Global.fx_volume = 0.0
	Global.showed_helparrow = []
	
	
	# holding item
	Global.item_name = null
	Global.box_item = null
	Global.player_holding_item = false
	
	
	# items
	Global.MOBO_item_name_list = []
	Global.MOBO_item_position_list = []
	Global.MOBO_box_item_list = []

	Global.CPU_item_name_list = []
	Global.CPU_item_position_list = []
	Global.CPU_box_item_list = []

	Global.SSD_item_name_list = []
	Global.SSD_item_position_list = []
	Global.SSD_box_item_list = []

	Global.RAM_item_name_list = []
	Global.RAM_item_position_list = []
	Global.RAM_box_item_list = []
	
	Global.spawn_mobo_item = true
	Global.spawn_ssd_item = true
	Global.spawn_ram_item = true
	Global.spawn_cpu_item = true
			
	Global.locker_state_dict2 = {}
	
	# tasks
	Global.task_ongoing = ""
	Global.task_ssd_pooleli = null
	Global.task_ram_pooleli = null
	Global.task_cpu_pooleli = null
	Global.task_menu_info_dict = {}
	Global.task_bin_num = null
	Global.subtask = 0
	Global.deliver_ram_item = null
	Global.deliver_cpu_item = null
	Global.delivered_ram_items = []
	Global.delivered_cpu_items = []
	
	Global.task_menu_first_task = false
	
	Global.locker_num_list = []
	Global.locker_dict_keys = null
	Global.new_ssd_lockers()
	
	if Global._world != null:
		Global._world.get_tree().reload_current_scene()
	
