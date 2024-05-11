extends Node

var player_inital_map_position = Vector2(-127, 74)
var player_facing_direction = 1
var player_spawn_location
var most_recent_scene
#var body_to_location

var player_position = Vector2(0,0)
var player_holding_item = false
var holding_item_name

var camera_zoom = Vector2(0,0)

var in_pickup_area
var in_BoxOpening_area
#var spawn_item
#var despawn_item

#@onready var _player = preload("res://player/player.tscn").instantiate()
#@onready var _player = $ysort/player
var _player = null
var player_skeleton
var _world = null
var _lockers = null
var _lockers2 = null
var _train = null
var _pause_menu
var train_pos = Vector2(-103,51)
var next_train_direction = false
var train_direction = true
var train_driving = false
var world_name
var item_name
var box_item
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

#var MOBO_items_dict = {}
var MOBO_item_name_list = []
var MOBO_item_position_list = []
var MOBO_box_item_list = []
#var MOBO_display_name_list = []

var CPU_item_name_list = []
var CPU_item_position_list = []
var CPU_box_item_list = []
#var CPU_display_name_list = []

var SSD_item_name_list = []
var SSD_item_position_list = []
var SSD_box_item_list = []

var RAM_item_name_list = []
var RAM_item_position_list = []
var RAM_box_item_list = []
#var SSD_display_name_list = []

var item_instance = load("res://world/item.tscn").instantiate() ##################

var _task_menu
var tasks = ["locate-SSD-info","deliver-SSD-info","deliver-RAM-info"]
var bin_tasks_completed = []
var bin_task_completed_last
var selected_task
var task_SSD_location

var task_binary_rows = []
var task_binary_num = 0
var all_randbin_nums = []
var task_ongoing = false

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

var ssd_lockers_instance = preload("res://world/ssd-lockers.tscn").instantiate()

var player_task_level_points = 0
var task_menu_first_task

var task_ssd_pooleli
var task_ram_pooleli
var task_cpu_pooleli
var task_ssd_finished = false
var task_cpu_finished = false
var task_ram_finished = false
var task_ssd_done
var task_ram_done
var task_cpu_done

var deliver_ram_item
var deliver_cpu_item
var delivered_ram_items = []
var delivered_cpu_items = []

var _ram_menu
var _controlpanel

var task_dec_num

var player_vignette


func _ready():
	# salvestatud info laadimine
	var load_saved_game = load("res://save_game.gd")
	load_saved_game.load_game()
	
	
	# kappide laadimine
	if lockers_loaded == false:
		self.add_child(ssd_lockers_instance)
		ssd_lockers_instance.hide()
		lockers_loaded = true
		
		ssd_lockers_instance.queue_free()

	# music
	
	var music_node = AudioStreamPlayer2D.new()
	music_node.stream = load("res://audio/Project_game.mp3")
	music_node.play()
	

func console():
	print("<CONSOLE>")

 

func _process(delta):
	# Spawning an item at set location for First load in. in _process cuz _world not loaded #
	#if item_status == true and _world != null:
		#item_status = false
		#_world.spawn_world_items()
		#print("=========spawning world items")
		#_world.add_child(item_instance)
		#item_instance.set_position(Vector2(213,145))

	# asjade üleskorjamine
	if player_holding_item == false and in_pickup_area == true and player_in_menu == false and Global.train_driving != true and Input.is_action_just_released("Interact_f"):
		_player.hold_item(item_name)
	
	elif player_holding_item == true and player_in_menu == false and Global.train_driving != true and Input.is_action_just_released("Interact_f"):
		_player.release_item(item_name, box_item)
	
	# kasti avamine
	if in_BoxOpening_area == true and player_holding_item == true and holding_item_name == "box1" and Input.is_action_just_released("Open_g"):
		_player.open_box(box_item)
		item_name = box_item
		#_player.release_item("box2")
	# kasti panemine
	if in_BoxOpening_area == true and player_holding_item == true and in_pickup_area == true and holding_item_name == "box2" and player_in_menu == false and Input.is_action_just_released("Open_g"):
		_player.store_box()
		
		
		
	# ÜLESANDED

	if selected_task == "SSD-to-RAM" and task_SSD_location == "Chrome.exe" and box_item == "chrome_exe":
		_task_menu.completeTask()
	

	
	
	

func spawn_item(item_name, item_pos, box_item): ## eseme loomine
	print("<",world_name,">: ",item_name,";",box_item, "' eseme loomine")
	if _world != null:
		var item_instance = load("res://world/item.tscn").instantiate()
		#var item_script = load("res://world/item.gd")
		#item_script.
		
		item_instance.set_item_name(item_name)
		item_instance.set_item_position(item_pos)
		item_instance.set_box_item(box_item)
		_world.get_node("ysort/items").add_child(item_instance)
		#####item_instance.get_node("Icon").texture = load("res://world/" + item_name + ".png")
		#if "kapi_kood1" in item_name:
			#item_instance.set_item_name("kapi_kood")
		
		if "kapi_kood1" in item_name:
			item_name = "kapi_kood " + item_name.split(" ")[1]
			item_instance.set_item_name(item_name)
		if "kood" in item_name:
			item_instance.get_node("Icon").texture = load("res://world/kapi_kood.png")
		if "task_item" in item_name:
			item_instance.get_node("Icon").texture = load("res://world/" + item_name.split(" ")[0] + ".png")
		if "info" in item_name:
			item_instance.get_node("Icon").texture = load("res://world/umbrik.png")
		
		##if item_name == "redel":
		##	var ladder_collision = CollisionPolygon2D.new()



func despawn_item(item_name): ## eseme eemaldamine
	print("<",world_name,">: ",item_name, "' eseme eemaldamine")
	holding_item_name = item_name
	if _world != null: #!!!!!!!!!!!!!!!!!!!! item_body is freed somewhere and results in an error !!!!!!!!!!!!!!!!!!!!!
		_world.get_node("ysort/items").remove_child(item_body)
	if Global.item_body != null:
		Global.item_body.despawning()
		#_world.remove_child(_world.get_node("item"))
	#control_panel_instance.reload_gui() ##############################################################################################################
	# eemalda item kapi listist  ??
	#if item_locker_pos in locker_state_dict:
		##locker_state_dict.erase(item_locker_pos)
		#locker_state_dict[item_locker_pos][1] = "empty"
		#print("EEMALDATUD KAPIST?: ", locker_state_dict)
	
	# ÜLESANDE LÕPETAMINE
	if "task_item" in item_name:
		print("ÜLESANDE LÕPETAMINE")
		Global.item_name = item_name.split(" ")[0]
		_controlpanel.reload_gui()
		Global.task_ssd_finished = true







