extends TileMap

var locker_file_label_dict = {}
var on_launch_labels = false

func _ready():
	Global._lockers2 = self
	Global.lockers_loaded2 = true
	print("RAM LOCKER ARE LOADED OAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	Global.items_in_lockers = {}


		## kapi numbrite hankimine
		#for i in range(0, 63):
			#var kapp_text = "kapp"
			#Global.locker2_info_list.append(kapp_text)
	#Global.locker_labels_dict[locker_text] = mouse_pos_int
	for el in Global.locker_state_dict2:#[mouse_pos_int][1] == "full":
		if Global.locker_state_dict2[el][1] == "full":
			add_locker_labels(el) #??<<<<<!!
	###print("==o==o==o==o==o==o==o==o==o==o==")
	###for el in Global.locker_labels_dict:
	###	#add_locker_labels(Global.locker_labels_dict[el])
	###	print("%%%%%%%%LABELS: ", Global.locker_labels_dict[el])
	reload_locker_labels()
	
	# kapi uksed on lahti/kinni stseeni alguses
	for el in Global.locker_state_dict2:
		if Global.locker_state_dict2[el][0] == "closed":
			set_cell(0, el, 0, Vector2i(0,0))
			#self.get_node(str(locker_file_label_dict[Vector2i(el)][0])).show()
		if Global.locker_state_dict2[el][1] == "full":
			set_cell(0, el, 0, Vector2i(1,0))
		if Global.locker_state_dict2[el][0] == "open":
			set_cell(0, el, 0, Vector2i(2,0))
			#self.get_node(str(locker_file_label_dict[Vector2i(el)][0])).hide()


func _process(_delta):
	for el in Global.locker_labels_dict:
		if el == null:
			Global.locker_labels_dict.erase(el)
	
	for el in Global.items_in_lockers: # no locker2 labels on first launch fix
		if el != null and on_launch_labels == false:
			#if el not in Global.items_in_lockers_wlabels:
				#Global.items_in_lockers_wlabels.append(el)
			add_locker_labels(el.item_pos_int)
			on_launch_labels = true
	
	
	var mouse_pos_resize = get_global_mouse_position()/7.5
	var mouse_pos_int = (Vector2(int(mouse_pos_resize[0]), int(mouse_pos_resize[1])))
	if self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(0,0) or self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(1,0):
		for el in Global.locker_labels_dict:
			if Global.locker_labels_dict[el][0] == mouse_pos_int:
				el.scroll_anim()

	if (Input.is_action_just_pressed("mb_left")) and Global.player_in_menu != true:

		# ava kapi uks
		if self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(0,0) or self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(1,0):
			set_cell(0, mouse_pos_resize, 0, Vector2i(2,0))
			if mouse_pos_int not in Global.locker_state_dict2:
				Global.locker_state_dict2[mouse_pos_int] = ["","empty"]
			Global.locker_state_dict2[mouse_pos_int][0] = "open"
			#self.get_node(str(locker_file_label_dict[Vector2i(mouse_pos_int)][0])).hide()
			#self.get_node(str(Global.locker_file_label_dict[Vector2i(mouse_pos_int)][0])).hide()
			for el in Global.item_bodies_list:
				el.update_item_visibility()
				remove_locker_labels(mouse_pos_int)
					
			print("state: ", Global.locker_state_dict2)
		
		# sulge kapi uks
		elif self.get_cell_atlas_coords(0, mouse_pos_resize) == Vector2i(2,0): #<<<<####################
			#self.get_node(str(locker_file_label_dict[Vector2i(mouse_pos_int)][0])).show()
			var popup_spawned = false
			for el in Global.item_bodies_list:
				if el.position == Vector2(mouse_pos_int.x *7.5 + 3.5, mouse_pos_int.y *7.5 + 4.8) and el.stacked_inlocker == true:
					if popup_spawned == false:
						popup_spawned = true
						Global.PopUpText("Liiga palju asju!", "mouse", Vector2.ZERO)
				elif el.position == Vector2(mouse_pos_int.x *7.5 + 3.5, mouse_pos_int.y *7.5 + 4.8) and el.item_name == "redel":
						popup_spawned = true
						Global.PopUpText("bruh", "mouse", 0)
			
			if popup_spawned == false:
				for el in Global.item_bodies_list:
					Global.locker_state_dict2[mouse_pos_int][0] = "closed"
					el.update_item_visibility()
				if Global.locker_state_dict2[mouse_pos_int][1] == "full":
					set_cell(0, mouse_pos_resize, 0, Vector2i(1,0))
					add_locker_labels(mouse_pos_int)
				if Global.locker_state_dict2[mouse_pos_int][1] == "empty" or Global.locker_state_dict2[mouse_pos_int][1] == "":
						set_cell(0, mouse_pos_resize, 0, Vector2i(0,0))
				
			print("state: ", Global.locker_state_dict2)



func remove_locker_labels(mouse_pos_int):
	#for el in self.get_children():
	for el in Global.items_in_lockers:
		if el.item_pos_int == mouse_pos_int:
			for en in Global.locker_labels_dict:
				if Global.locker_labels_dict[en][0] == mouse_pos_int:
					Global.locker_labels_dict.erase(en)
					self.remove_child(en)
					en.queue_free()

func add_locker_labels(mouse_pos_int):
	print("add_locker_label 💮💮💮💮💮💮")
	
	#remove_locker_labels()
	for el in Global.items_in_lockers:
		print("💮")
		#print(el.item_pos_int, " ===|=== ", mouse_pos_int)
		if el.item_pos_int == mouse_pos_int:
			print("💮💮")
			var locker_text = load("res://world/lockers_text.tscn").instantiate()
			locker_text.position = Vector2(((el.position.x * 10)-26), ((el.position.y * 10)-44)) #get_global_mouse_position()
			self.add_child(locker_text)
			Global.locker_labels_dict[locker_text] = ["", "", ""]
			Global.locker_labels_dict[locker_text][0] = mouse_pos_int
			Global.locker_labels_dict[locker_text][1] = locker_text.position
			
			if ".exe" in el.item_name or ".png" in el.item_name or ".mp4" in el.item_name or ".mp3" in el.item_name or ".txt" in el.item_name:
				locker_text.set_text(str(el.item_name),locker_text.color_file)
				Global.locker_labels_dict[locker_text][2] = str(el.item_name)
				
			else:
				locker_text.set_text("error!",locker_text.color_error)
				Global.locker_labels_dict[locker_text][2] = "error!"

func reload_locker_labels():
	#remove_locker_labels()
	for el in Global.locker_labels_dict: # { <Freed Object>: [(30, 18), "chrome_exe"] }
		if el == null:
			var locker_text = load("res://world/lockers_text.tscn").instantiate()
			locker_text.position = Global.locker_labels_dict[el][1]
			self.add_child(locker_text)
			Global.locker_labels_dict[locker_text] = ["", "", ""]
			Global.locker_labels_dict[locker_text][0] = Global.locker_labels_dict[el][0]
			Global.locker_labels_dict[locker_text][1] = Global.locker_labels_dict[el][1]
			
			if ".exe" in Global.locker_labels_dict[el][2] or ".png" in Global.locker_labels_dict[el][2] or ".mp4" in Global.locker_labels_dict[el][2] or ".mp3" in Global.locker_labels_dict[el][2] or ".txt" in Global.locker_labels_dict[el][2]:
				locker_text.set_text(str(Global.locker_labels_dict[el][2]),locker_text.color_file)
				Global.locker_labels_dict[locker_text][2] = str(Global.locker_labels_dict[el][2])
					
			else:
				locker_text.set_text("error!",locker_text.color_error)
				Global.locker_labels_dict[locker_text][2] = "error!"
