extends TileMap

var locker_file_label_dict = {}

func _ready():
	Global._lockers2 = self
	if Global.lockers_loaded2 == false:
		Global.lockers_loaded2 = true
	
	Global.items_in_lockers = {}

		## kapi numbrite hankimine
		#for i in range(0, 63):
			#var kapp_text = "kapp"
			#Global.locker2_info_list.append(kapp_text)
	
	#add_locker_labels()
	
	# kapi uksed on lahti/kinni stseeni alguses
	for el in Global.locker_state_dict2:
		if Global.locker_state_dict2[el][0] == "open":
			set_cell(0, el, 0, Vector2i(2,0))
			#self.get_node(str(locker_file_label_dict[Vector2i(el)][0])).hide()
		if Global.locker_state_dict2[el][0] == "closed":
			set_cell(0, el, 0, Vector2i(0,0))
			#self.get_node(str(locker_file_label_dict[Vector2i(el)][0])).show()
		if Global.locker_state_dict2[el][1] == "full":
			set_cell(0, el, 0, Vector2i(1,0))
		
		#print("AFSASFASFAFS,:,: ", el)
		
		
func _process(delta):
	
	if (Input.is_action_just_pressed("mb_left")) and Global.player_in_menu != true:
		var mouse_pos_resize = get_global_mouse_position()/7.5
		var mouse_pos_int = (Vector2(int(mouse_pos_resize[0]), int(mouse_pos_resize[1])))
		
		# ava kapi uks
		if self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(0,0) or self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(1,0):
			set_cell(0, mouse_pos_resize, 0, Vector2i(2,0))
			if mouse_pos_int not in Global.locker_state_dict2:
				Global.locker_state_dict2[mouse_pos_int] = ["","empty"]
			Global.locker_state_dict2[mouse_pos_int][0] = "open"
			#self.get_node(str(locker_file_label_dict[Vector2i(mouse_pos_int)][0])).hide()
			#self.get_node(str(Global.locker_file_label_dict[Vector2i(mouse_pos_int)][0])).hide()
			for el in Global.item_bodies_list:
				if el != null:
					el.update_item_visibility()
					remove_locker_labels(mouse_pos_int)
					
			print("state: ", Global.locker_state_dict2)
		
		
		# sulge kapi uks
		elif self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(2,0):
			Global.locker_state_dict2[mouse_pos_int][0] = "closed"
			#self.get_node(str(locker_file_label_dict[Vector2i(mouse_pos_int)][0])).show()
			for el in Global.item_bodies_list:
				if el != null:
					el.update_item_visibility()
					#print("mouse_pos_resize-----:", mouse_pos_resize)
					
			
			if Global.locker_state_dict2[mouse_pos_int][1] == "full":
				set_cell(0, mouse_pos_resize, 0, Vector2i(1,0))
				add_locker_labels(mouse_pos_int)
			if Global.locker_state_dict2[mouse_pos_int][1] == "empty" or Global.locker_state_dict2[mouse_pos_int][1] == "":
				set_cell(0, mouse_pos_resize, 0, Vector2i(0,0))
			
			print("state: ", Global.locker_state_dict2)


var locker_labels_dict = {}

func remove_locker_labels(mouse_pos_int):
	#for el in self.get_children():
	for el in Global.items_in_lockers:
		if el.item_pos_int == mouse_pos_int:
			print("el.item_pos_int == mouse_pos_int")
			for en in locker_labels_dict:
				if locker_labels_dict[en] == mouse_pos_int:
					print("locker_labels_dict[en] == mouse_pos_int")
					locker_labels_dict.erase(en)
					self.remove_child(en)
					en.queue_free()

func add_locker_labels(mouse_pos_int):
	#remove_locker_labels()
	for el in Global.items_in_lockers:
		#print(el.item_pos_int, " ===|=== ", mouse_pos_int)
		if el.item_pos_int == mouse_pos_int:
			var locker_label =  Label.new()
			locker_label.name = str(el.item_name)
			locker_label.position = Vector2(((el.position.x * 10)-26), ((el.position.y * 10)-44))
			locker_label.modulate = "8080f0"
			locker_label.size.x = 70
			locker_label.scale = Vector2(0.8,0.8)
			locker_label.clip_text = true
			#print("--LOCKER_LABEL.POSITION--", locker_label.position, " --name--", el.item_name)
			self.add_child(locker_label)
			locker_labels_dict[locker_label] = mouse_pos_int
			print("add to locker_labels_dict: ", locker_labels_dict)
			if "_exe" in el.item_name or "_file" in el.item_name:
				locker_label.text = str(el.item_name)
			else:
				locker_label.modulate = "f08080"
				locker_label.text = "error!"
		#Global.locker_state_dict2[mouse_pos_int][1] == "empty"
		
		
		
		#Global.locker_file_label_dict[el].append(loendur+1)
		#Global.locker_file_label_dict[el].append(Global.locker_num_list[loendur])
		#locker_num_dict[Global.locker_num_list[loendur]] = []
		#locker_num_dict[Global.locker_num_list[loendur]].append(loendur+1)
		#locker_num_dict[Global.locker_num_list[loendur]].append(el)
		#Global.locker_info_dict2 = locker_num_dict
		#loendur += 1
	
	
