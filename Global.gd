extends Node

var player_inital_map_position = Vector2(-772, 80)
var player_facing_direction = 1
var player_spawn_location
var most_recent_scene
#var body_to_location

var player_position = Vector2(0,0)
var player_holding_item = false
var holding_item_name
var scene_savepos

var camera_zoom = Vector2(0,0)

var language = "eesti"

var earned_achievments = []

var feedback_dict = {}

var in_pickup_area
var in_BoxOpening_area
#var spawn_item
#var despawn_item

#@onready var _player = preload("res://player/player.tscn").instantiate()
#@onready var _player = $ysort/player
var _player = null
var player_skeleton
var click_tp = false
var _world = null
var _lockers = null
var _lockers2 = null
var _train = null
var _pause_menu
var _info_panel = []
var _task_bar
var train_pos = Vector2(-87, 41.725)
var next_train_direction = false
var train_direction = true
var train_driving = false
var rongirajatroll = false
var world_name
var item_name
var box_item
var unique_item_id = 0
var unique_task_id = 0
var item_body
var in_item_area
var player_in_menu = false
var item_bodies_list = []

var item_status = true
var spawn_mobo_item = true
var spawn_cpu_item = true
var spawn_ssd_item = true
var spawn_ram_item = true

# stseenis esemete salvestamine
var save_items
var can_save_world_items = false

#var MOBO_items_dict = {}
var MOBO_item_id_list = []
var MOBO_item_name_list = []
var MOBO_item_position_list = []
var MOBO_box_item_list = []
#var MOBO_display_name_list = []

var CPU_item_id_list = []
var CPU_item_name_list = []
var CPU_item_position_list = []
var CPU_box_item_list = []
#var CPU_display_name_list = []

var SSD_item_id_list = []
var SSD_item_name_list = []
var SSD_item_position_list = []
var SSD_box_item_list = []

var RAM_item_id_list = []
var RAM_item_name_list = []
var RAM_item_position_list = []
var RAM_box_item_list = []
#var SSD_display_name_list = []


var _task_menu
var tasks = ["SSD-task","RAM-task","CPU-task"]
var bin_tasks_completed = []
var bin_task_completed_last
var selected_task
var task_SSD_location
var _task_binary
var _task_decimal

var task_binary_rows = []
var task_binary_num = 0
var all_randbin_nums = []
var task_ongoing = ""
var task_ongoing_block
var subtask = 0

var lockers_loaded = false
var lockers_loaded2 = false
var locker_bin_num_list = []
var locker_num_list = []
var locker_state_dict = {}
var item_locker_pos
var task_bin_num
var task_bin_num_in_dec
var locker_info_dict = {}
var locker_num_dict_temp = {}
var bin_task_finished = 0
var finished_task = false
var bin_task_item_spawned = false

var locker_state_dict2 = {}
var locker2_info_list = []
var locker_info_dict2 = {}
var task_menu_info_dict = {}
var items_in_lockers = {}
var items_in_lockers_wlabels = []
var locker_labels_dict = {}
var locker_dict_keys
var files_list = []
#var ssd_lockers_instance = preload("res://world/ssd-lockers.tscn").instantiate()

var player_task_level_points = 0
var task_menu_first_task = false

var task_ssd_pooleli
var task_ram_pooleli
var task_cpu_pooleli
var task_ssd_finished = false
var task_cpu_finished = false
var task_ram_finished = false
var task_ssd_done = ""
var task_ram_done = ""
var task_cpu_done = ""

var deliver_ram_item
var deliver_cpu_item
var delivered_ram_items = []
var delivered_cpu_items = []

var _ram_menu
var _controlpanel
var _cpu_menu

var task_dec_num = null

var player_vignette
var music_volume = 0.0
var fx_volume = 0.0

var HelpArrow
var helparrow_state = "task" #   del  = "task"
var helparrow_states = ["task", "taskblock", "ssd_menu", "done_1st_task", "done_1st_taskblock", "ram_menu", "cpu_menu", "next"]
var helparrow_state_loendur = 0
var showed_helparrow = []

func add_HelpArrow(add_to_body : Object, arrow_pos : Vector2, arrow_size : int):
	pass
	#HelpArrow = load("res://menu/help_arrow.tscn").instantiate()
	#add_to_body.add_child(HelpArrow)
	#HelpArrow.position = arrow_pos
	#HelpArrow.scale = Vector2(arrow_size, arrow_size)
	#print("<*> Add 'HelpArrow' ; helparrow_state: ", helparrow_state)
	

func remove_HelpArrow(remove_from_body): # ma vihkan seda funktiooni, see toob palju erroreid ja ma ei kasuta seda, ! pea meeles et pean selle mujal ümber töötama!
	pass
	#if len(helparrow_states) > helparrow_state_loendur+1:
		#helparrow_state_loendur += 1
	#helparrow_state = helparrow_states[helparrow_state_loendur]
	##print("<*> remove_from_body: ", remove_from_body, ", HelpArrow: ", HelpArrow)	
	#if HelpArrow != null and remove_from_body != null:
		#remove_from_body.remove_child(HelpArrow)
	#else:
		#print("*❗ NULL INSTANCE: HelpArrow: ", HelpArrow, ", remove_from_body: ", remove_from_body)
	#print("<*> Remove 'HelpArrow' ; helparrow_state (next): ", helparrow_state)	


func _ready():
	SaveGame.load_settings()
	
	
	
func start_game():
	# salvestatud info laadimine
	#var load_saved_game = load("res://save_game.gd")
	#load_saved_game.load_game()
	SaveGame.load_settings()
	SaveGame.load_game()
	
	var ssd_lockers_gd = load("res://world/ssd-lockers.tscn").instantiate()
	ssd_lockers_gd.create_locker_texts()

#func new_ssd_lockers(): # ssd kappide loomine
#	print("creating new_ssd_lockers...")
#	var ssd_lockers_gd = load("res://world/ssd-lockers.tscn").instantiate()
#	ssd_lockers_gd.create_locker_texts()
	
	
	## music
	#var music_node = AudioStreamPlayer2D.new()
	#music_node.stream = load("res://audio/Project_game.mp3")
	##music_node.play()


func save_world_items():
	print("*♻ <", world_name, "> saving all items")
	
	if _world != null and world_name != null:
		get(world_name + "_item_id_list").clear()
		get(world_name + "_item_name_list").clear()
		get(world_name + "_item_position_list").clear()
		get(world_name + "_box_item_list").clear()
		
		for i in _world.get_node("ysort/items").get_children():
			if i.saving == true:
				i.save_item()
	
		


func _process(_delta):
	# Spawning an item at set location for First load in. in _process cuz _world not loaded #
	#if item_status == true and _world != null:
		#item_status = false
		#_world.spawn_world_items()
		#print("=========spawning world items")
		#_world.add_child(item_instance)
		#item_instance.set_position(Vector2(213,145))
	###if (Input.is_action_just_pressed("mb_left")) and player_in_menu != true and _world != null:
	###	PopUpCursor(".")
	
	for el in item_bodies_list:
		if el == null:
			item_bodies_list.erase(el)
	
	for el in task_binary_rows:
			if el == null:
				task_binary_rows.erase(el)
	
	#if world_name == "RAM":
		#for el in items_in_lockers: # no locker2 labels on first launch fix
			#if el != null:
				#if el not in items_in_lockers_wlabels:
					#items_in_lockers_wlabels.append(el)
					#_lockers2.add_locker_labels(el.item_pos_int)
	
	
	if _player != null:
		# asja üleskorjamine
		if Input.is_action_just_released("Interact_f") and player_holding_item == false and in_pickup_area == true and player_in_menu == false and train_driving != true and item_body.visible == true:
			_player.hold_item(item_name)
		# asja mahapanemine
		elif Input.is_action_just_released("Interact_f") and player_holding_item == true and player_in_menu == false and train_driving != true:
			_player.release_item(item_name, box_item)
	
		# kasti avamine
		if Input.is_action_just_released("Open_g") and in_BoxOpening_area == true and player_holding_item == true and holding_item_name == "box1":
			_player.open_box(box_item)
			##item_name = box_item
			#_player.release_item("box2")
		# kasti panemine
		if Input.is_action_just_released("Open_g") and in_BoxOpening_area == true and player_holding_item == true and in_pickup_area == true and holding_item_name == "box2" and player_in_menu == false:
			_player.store_box()
		
		if Input.is_action_just_released("Throw_v") and holding_item_name == "egg.exe":
			_player.throw_item()
			print("es")
		
		


var last_tile_value
func PopUpText(popup_text : String, pos, tile_value):
	if tile_value != last_tile_value:
		last_tile_value = tile_value
		var kapi_popup_text = load("res://menu/popup_text.tscn").instantiate()
		_world.add_child(kapi_popup_text)
		kapi_popup_text.popup(popup_text, pos)
		await kapi_popup_text.get_node("AnimationPlayer").animation_finished
		last_tile_value = null


func PopUpCursor(cursor_text : String):
	#if kapi_pptext_timer == true:
	var popup_cursor_text = load("res://menu/popup_text.tscn").instantiate()
	_world.add_child(popup_cursor_text)
	popup_cursor_text.popup(cursor_text, "cursor")
	await popup_cursor_text.get_node("AnimationPlayer").animation_finished


func spawn_item(the_item_name, the_item_pos, the_box_item, special_id = ""): ## eseme loomine
	print("➕ <",world_name,"> Spawning item: ",the_item_name,", ",the_item_pos, ", ", the_box_item)
	if _world != null:
		var item_instance = load("res://world/item.tscn").instantiate()
		#var item_script = load("res://world/item.gd")
		#item_script.
		
		item_instance.set_item_name(the_item_name)
		item_instance.set_item_position(the_item_pos)
		item_instance.set_box_item(the_box_item)
		
		_world.get_node("ysort/items").add_child(item_instance)
		
		if special_id == "egg.exe":
			item_instance.easter_egg = true
		elif special_id == "throw_egg":
			item_instance.throw_easteregg()
			
		#####item_instance.get_node("Icon").texture = load("res://world/" + the_item_name + ".png")
		#if "kapi_kood1" in the_item_name:
			#item_instance.set_item_name("kapi_kood")
		
		if "kapi_kood1" in the_item_name:
			the_item_name = "kapi_kood " + the_item_name.split(" ")[1]
			item_instance.set_item_name(the_item_name)
		if "kood" in the_item_name:
			item_instance.get_node("Icon").texture = load("res://world/kapi_kood.png")
		if "task_item" in the_item_name:
			item_instance.get_node("Icon").texture = load("res://world/" + the_item_name.split(" ")[0] + ".png")
		if "info" in the_item_name:
			item_instance.get_node("Icon").texture = load("res://world/umbrik.png")
		
		if the_box_item == "redel" and the_item_name == "box1":
			item_instance.get_node("Icon").texture = load("res://world/redel_box.png")
			
		
		##if the_item_name == "redel":
		##	var ladder_collision = CollisionPolygon2D.new()



func despawn_item(the_item_name): ## eseme eemaldamine
	print("➖ <",world_name,"> Despawn item: ",the_item_name)
	holding_item_name = the_item_name
	if _world != null: #!!!!!!!!!!!!!!!!!!!! item_body is freed somewhere and results in an error !!!!!!!!!!!!!!!!!!!!!
		_world.get_node("ysort/items").remove_child(item_body)
	if item_body != null:
		item_body.despawning(true)
		#_world.remove_child(_world.get_node("item"))
	#control_panel_instance.reload_gui() ##############################################################################################################
	# eemalda item kapi listist  ??
	#if item_locker_pos in locker_state_dict:
		##locker_state_dict.erase(item_locker_pos)
		#locker_state_dict[item_locker_pos][1] = "empty"
		#print("EEMALDATUD KAPIST?: ", locker_state_dict)
	
	# ÜLESANDE LÕPETAMINE
	if "task_item" in the_item_name:
		print("<*> ÜLESANDE LÕPETAMINE")
		item_name = the_item_name.split(" ")[0]
		_controlpanel.reload_gui()
		Global.task_ongoing_block.complete_ssd_task()







