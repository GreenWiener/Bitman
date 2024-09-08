extends TileMap


func _ready():
	Global._lockers = self
	#if Global.lockers_loaded == false:
	#	Global.lockers_loaded = true
		
		## kapi numbrite hankimine
		#for i in range(0, 63):
			#var locker_bin_num = random_binary_num()
			#Global.locker_bin_num_list.append(locker_bin_num)
			#print(Global.locker_bin_num_list)
			#Global.locker_num_list.append(binary_to_demical(locker_bin_num))
		#
		#Global.locker_num_list.sort()
		#print("Global.locker_num_list: ", Global.locker_num_list)
	
	# kapi asukohtade järjestamine
	#Global.locker_num_dict_temp = {}
	#for el in get_used_cells(0):
		#Global.locker_num_dict_temp[el] = []
	#var Global.locker_dict_keys = Global.locker_num_dict_temp.keys()
	#Global.locker_dict_keys.sort()
	#print("KEYS: ", Global.locker_dict_keys)
	
	# teksti lisamine
	var loendur = 0
	for el in Global.locker_dict_keys:
		var locker_num_label =  Label.new()
		locker_num_label.name = str(loendur+1)
		locker_num_label.position = Vector2((el.x * 75 + 9), (el.y * 75 + 2))  #el * 75
		self.add_child(locker_num_label)
		locker_num_label.text = str(Global.locker_num_list[loendur])
		loendur += 1
	
	# kapi uksed on lahti/kinni stseeni alguses
	#for el in Global.locker_state_dict:
		#if Global.locker_state_dict[el][0] == "open":
			#set_cell(0, el, 1, Vector2i(1,0))
			#self.get_node(str(Global.locker_num_dict_temp[Vector2i(el)][0])).hide()
		#if Global.locker_state_dict[el][0] == "closed":
			#set_cell(0, el, 1, Vector2i(0,0))
			#self.get_node(str(Global.locker_num_dict_temp[Vector2i(el)][0])).show()


func create_locker_texts():
	for i in range(0, 63):
		var locker_bin_num = random_binary_num()
		Global.locker_bin_num_list.append(locker_bin_num)
		#print(Global.locker_bin_num_list)
		Global.locker_num_list.append(binary_to_demical(locker_bin_num))
	
	Global.locker_num_list.sort()

	Global.locker_num_dict_temp = {}
	for el in get_used_cells(0):
		Global.locker_num_dict_temp[el] = []
	Global.locker_dict_keys = Global.locker_num_dict_temp.keys()
	Global.locker_dict_keys.sort()
	#print("KEYS: ", Global.locker_dict_keys)

	var loendur = 0
	var locker_num_dict = {}
	for el in Global.locker_dict_keys:
		Global.locker_num_dict_temp[el].append(loendur+1)
		Global.locker_num_dict_temp[el].append(Global.locker_num_list[loendur])
		locker_num_dict[Global.locker_num_list[loendur]] = []
		locker_num_dict[Global.locker_num_list[loendur]].append(loendur+1)
		locker_num_dict[Global.locker_num_list[loendur]].append(el)
		Global.locker_info_dict = locker_num_dict
		loendur += 1


func spawn_item_in_locker(): # asjade lisamine kappi
	print("1¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤1")
	for el in Global.locker_info_dict:
		print("2¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤2")
		if el == Global.task_bin_num_in_dec:
			print("3¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤===¤¤¤3")
			#print("1kapis ", el, " on fail")
			#print("2kapis ", Global.locker_info_dict[el][1], " on fail")
			#print("3kapis ", Global.locker_info_dict[el][1]*7.5, " on fail")
			#var rand_box_items = ["chrome.exe","vlc.exe","video.mp4","picture.png","music.mp3","text.txt"]
			
			var files_list = []
			var files_txt = FileAccess.open("res://world/files.txt",FileAccess.READ)
			while files_txt.get_position() < files_txt.get_length():
				var files_txt_lines = files_txt.get_line()
				if files_txt_lines != "" and "#" not in files_txt_lines:
					files_list.append(files_txt_lines)
			print("files_list: ", files_list)
			
			var rand_box_item = files_list[randi_range(0,len(files_list)-1)]
			files_list.erase(rand_box_item)

			#Global.locker_state_dict[Vector2(Global.locker_info_dict[el][1])] = ["closed","full"]
			Global.spawn_item("box1 task_item", Vector2((Global.locker_info_dict[el][1].x * 7.5) + 3.5,(Global.locker_info_dict[el][1].y * 7.5) + 4.7), rand_box_item) # 3.5 ????????
			
			print("📮 <ssd-lockers> Spawning in locker: box1 task_item, ", rand_box_item)
	
	
	#print("LOCKER_INFO_DICT: ", Global.locker_info_dict)
	#print("LOCKER_NUM_DICT_TEMP: ", Global.locker_num_dict_temp)

	


func random_binary_num():
	var number_found = false
	var randbin_nums
	while number_found == false:
		randbin_nums = ["1"]
		for i in randi_range(1, 9):
			var temp = str(randi_range(0, 1))
	 		
			randbin_nums.append(temp)
		var randbin_num = "".join(randbin_nums)
		if randbin_num not in Global.all_randbin_nums:
			Global.all_randbin_nums.append(randbin_num)
			number_found = true
	return "".join(randbin_nums)

func binary_to_demical(binary_num):
	var calculated_answer = 0
	var aste = len(binary_num)-1
	#print("binary_num: ", binary_num)
	for i in binary_num:
		var calculation = int(i) * 2 ** aste
		calculated_answer += calculation
		#print("i: ", i, " aste: ", aste)
		aste -= 1
	return calculated_answer

func _process(_delta):
	#var item_pos
	#if not item_pos in Global.locker_state_dict and Global.locker_state_dict[item_pos][1] == "full":
		#Global.locker_state_dict[item_pos][1] = "empty"

	#if Global.bin_task_finished == Global.bin_task_completed_last: ###
		#Global.bin_task_item_spawned = false ###
		
	if (Input.is_action_just_pressed("mb_left")) and Global.player_in_menu != true:
		#var tilePos : Vector2 = local_to_map(get_global_mouse_position())
		var mouse_pos_resize = get_global_mouse_position()/7.5
		var mouse_pos_int = (Vector2(int(mouse_pos_resize[0]), int(mouse_pos_resize[1])))
		
		# ava kapi uks
		#print(mouse_pos_int, " == ", Vector2(Global.locker_info_dict[Global.bin_task_completed_last][1]))
		if self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(0,0) and Global.bin_task_completed_last in Global.locker_info_dict and mouse_pos_int == Vector2(Global.locker_info_dict[Global.bin_task_completed_last][1]) and Global.holding_item_name == "kapi_kood " + str(Global.bin_task_completed_last):
			set_cell(0, mouse_pos_resize, 1, Vector2i(1,0))
			if mouse_pos_int not in Global.locker_state_dict:
				Global.locker_state_dict[mouse_pos_int] = ["",""]
			Global.locker_state_dict[mouse_pos_int][0] = "open"
			
			self.get_node(str(Global.locker_num_dict_temp[Vector2i(mouse_pos_int)][0])).hide()
			
			for el in Global.item_bodies_list:
				el.update_item_visibility()
			
			# pane item kappi
			if "SSD-task" in Global.task_ongoing:
				AudioPlayer.play_fx("res://audio/locker_unlock.wav")
				Global.locker_state_dict[mouse_pos_int][1] = "full"
				spawn_item_in_locker()
				Global._player.release_item(null, null) # eemalda ukse kood käest
				Global.bin_task_item_spawned = true
			print("📮 <ssd-lockers> locker_state_dict: ", Global.locker_state_dict)
		
		
		# sulge kapi uks
		elif self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(1,0):
			if Global.locker_state_dict[mouse_pos_int][1] != "full":
				set_cell(0, mouse_pos_resize, 1, Vector2i(0,0))
				Global.locker_state_dict[mouse_pos_int][0] = "closed"
				print("📮 <ssd-lockers> locker_state_dict: ", Global.locker_state_dict)
				
				self.get_node(str(Global.locker_num_dict_temp[Vector2i(mouse_pos_int)][0])).show()
				
				for el in Global.item_bodies_list:
					el.update_item_visibility()
			else:
				if mouse_pos_int.y != 19:
					if Global.language == "english" or Global.language == "skibidi":
						Global.PopUpText("Too far away!", "mouse", Vector2.ZERO)
					else:
						Global.PopUpText("Ei ulatu võtta!", "mouse", Vector2.ZERO)
					AudioPlayer.play_fx("res://audio/beep_bad.wav")

		# lukus kapi uks
		elif self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(0,0):
			print("📮 <ssd-lockers> locker_state_dict: ", Global.locker_state_dict)
			if Global.holding_item_name != null and "kapi_kood " in Global.holding_item_name:
				#var kapi_popup_text = load("res://menu/popup_text.tscn").instantiate()
				#self.add_child(kapi_popup_text)
				#kapi_popup_text.popup()
				Global.PopUpText("Vale kapp!", "mouse", mouse_pos_int)
				AudioPlayer.play_fx("res://audio/locker_locked.wav")
			else:
				if Global.language == "english" or Global.language == "skibidi":
					Global.PopUpText("Locked!", "mouse", mouse_pos_int)
				else:
					Global.PopUpText("Kapp on lukus!", "mouse", mouse_pos_int)
				AudioPlayer.play_fx("res://audio/locker_locked.wav")
		
				#var kapi_state_label = Label.new()
				#self.add_child(kapi_state_label)
				#kapi_state_label.text = "Kapp on lukus!"
				#kapi_state_label.scale = Vector2(0.6,0.6)
				#kapi_state_label.pivot_offset = Vector2(58,10)
				#kapi_state_label.modulate = "ffffff00"
				#kapi_state_label.position = get_local_mouse_position() - Vector2(50,10)
				#print(get_global_mouse_position())
				#var tween_in = self.create_tween()
				#var tween_size = self.create_tween()
				#var tween_out = self.create_tween()
				#tween_in.tween_property(kapi_state_label, "modulate:a", 81, 1)
				#tween_size.tween_property(kapi_state_label, "scale", Vector2(1,1), 2)
				#await tween_in.finished
				##tween_out.tween_property(kapi_state_label, "modulate:a", 00, 1)
				##await tween_out.finished
				#self.remove_child(kapi_state_label)
		

