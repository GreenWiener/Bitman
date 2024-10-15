extends CharacterBody2D
class_name Player

@onready var hand1 = $"skeleton/player-arm1"
@onready var hand2 = $"skeleton/player-arm2"
var hand1_rotation_switch = false
var hand2_rotation_switch = true
@onready var leg1_pos = $"skeleton/player-leg1"
@onready var leg2_pos = $"skeleton/player-leg2"
var leg1_pos_switch = true
var leg2_pos_switch = false
var mapinicator_pos0 = 0
var mapinicator_pos1 = 0
var mapinicator_pos2 = 0
var mapinicator_pos3 = 0

var console_focus = false
var entered_portal = false

var locker_position = Vector2.ZERO
var inside_a_locker = false

var interact_f_label
var interact_g_label
var interact_g_label2
var interact_v_label

var welcome_text_close = false

@onready var task_btn = $CanvasLayer/Buttons/SideButtons/task_btn
@onready var task_menu = $CanvasLayer/Buttons/SideButtons/Control/task_menu
@onready var task_bar = $CanvasLayer/Buttons/task_bar
@onready var keyb_btn = $CanvasLayer/Buttons/keyb_btn

@onready var item_info = $CanvasLayer/holding_item_info/item_info

var walk_sfx = load("res://audio/walk.wav")
var walk2_sfx = load("res://audio/walk_reverb1.wav")

func _ready() -> void: ## funktsioon, mis käivitub, stseen on ära laadinud
	Global._player = self # Global skriptis muutuja _player määramine mängijaks
	Global.player_skeleton = $skeleton
	Global.player_vignette = $CanvasLayer/vignette
	$CanvasLayer/vignette.show()
	self.global_position = Global.player_inital_map_position # mängija asukoht stseeni alguses
	 
	$AnimationPlayer2.play("heart_beat")
	
	refresh_item(Global.item_name, Global.box_item) # kontrollib mängija käes olevate asju
	
	
	# Help Arrow
	#if Global.helparrow_state == "task":
		##Global.add_HelpArrow(task_btn, Vector2(-12,20), 2)
		#$CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow.show()
	#elif Global.helparrow_state == "done_1st_task" and Global.task_ssd_done != "":
		##Global.add_HelpArrow(task_btn, Vector2(-12,20), 1)
		#$CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow.show()
	if "task1" not in Global.showed_helparrow and "welcome_menu" in Global.showed_helparrow:
		$CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow.visible = true
	
	
	if "welcome_menu" not in Global.showed_helparrow:
		$CanvasLayer/Welcome_Text.visible = true
		Global.showed_helparrow.append("welcome_menu")
		Global.player_in_menu = true
		ui_visibility(false)
		welcome_text_close = true
	else:
		if "Android" in OS.get_name():
			$CanvasLayer/Movement.visible = true
		
	
	
	if Global.scene_savepos != null:
		self.position = Global.scene_savepos
		Global.scene_savepos = null
	
	var i_label_type 
	if "Android" in OS.get_name():
		$CanvasLayer/Buttons/SideButtons.scale = Vector2(0.47, 0.47)
		i_label_type = "InteractionLabels_android"
		get_node("CanvasLayer/holding_item_info/InteractionLabels/interact_f_label").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels/interact_g_label").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels/interact_v_label").visible = false
		keyb_btn.visible = false
		
	else:
		$CanvasLayer/Buttons/SideButtons.scale = Vector2(0.38, 0.38)
		i_label_type = "InteractionLabels"
		get_node("CanvasLayer/holding_item_info/InteractionLabels_android/interact_f_label").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label2").visible = false
		get_node("CanvasLayer/holding_item_info/InteractionLabels_android/interact_v_label").visible = false
	
	interact_f_label = get_node("CanvasLayer/holding_item_info/" + i_label_type + "/interact_f_label")
	interact_g_label = get_node("CanvasLayer/holding_item_info/" + i_label_type + "/interact_g_label")
	interact_g_label2 = get_node("CanvasLayer/holding_item_info/" + i_label_type + "/interact_g_label2")
	interact_v_label = get_node("CanvasLayer/holding_item_info/" + i_label_type + "/interact_v_label")
	
	
	
var VELOCITY = Vector2.ZERO # mängutegelase kiiruse vektor

#@export var float_number: float = 5

@export var MAX_SPEED = 30 # mängutegelase maksimaalne kiirus
const ACCELERATION = 300 # mängutegelase kiirenduse suurus
const FRICTION = 300 # mängutegelase hõõrdumise suurus

var delta_value

var player_pos_resize
var player_pos_int

var skibidi_points

func _physics_process(delta): ## mängija omadused ja füüsika, jookseb kogu aeg, kui stseen on laetud
	delta_value = delta
	Global.player_position = position # mängija asukoht Global skriptis kasutamiseks
	player_pos_resize = position/7.5
	player_pos_int = (Vector2(int(player_pos_resize.x), int(player_pos_resize.y+0.2)))
	#print(player_pos_int)
	
	skibidi_points = []
	var actual_points = Global.player_task_level_points / 10
	for i in range(0, actual_points):
		skibidi_points.append("💩")
	skibidi_points = "".join(skibidi_points)
	
	if Global.language == "english":
		lang_english()
		
	elif Global.language == "skibidi":
		lang_skibidi()
	else:
		lang_estonian()
	
	#$CanvasLayer/debug_menu.text = str("pos: ",position.round(),"\nin_pickup_area: ",Global.in_pickup_area,", ",Global.item_name,"\nplayer_holding_item: ",Global.player_holding_item,"\nholding_item_name: ",Global.holding_item_name,"\nMOBO_item_name_list: ", Global.MOBO_item_name_list,"\nMOBO_item_position_list: ", Global.MOBO_item_position_list,"\nCPU_item_name_list: ", Global.CPU_item_name_list,"\nCPU_item_position_list: ", Global.CPU_item_position_list) # info ekraanil
	



	## P saavutus
	#if Input.is_action_just_pressed("P") and Global.player_in_menu != true and "Achievement4" not in Global.earned_achievments:
		#Global.earned_achievments.append("Achievement4")
		#earned_an_achievment("Achievement4")
	
	#if Global.world_name != null:
		#var item_name_list = world_name + "_item_name_list"
		#var item_position_list = world_name + "_item_position_list"
		#var box_item_list = world_name + "_box_item_list"
		#
		#var get_item_name_list = get(item_name_list)
		#var get_item_position_list = get(item_position_list)
		#var get_box_item_list = get(box_item_list)
		#get_item_name_list = []
		#get_item_position_list = []
		#get_box_item_list = []
	
	
	#print(get(bob2))
	# liikumis klahvid ja loogika
	var input_vector = Vector2.ZERO # klahvisisendi vektor
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
#	if input_vector != Vector2.ZERO:  # acceleration when starting
#		VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#		#VELOCITY += input_vector * ACCELERATION * delta
#		#VELOCITY = VELOCITY.clamped(MAX_SPEED)
#	else: # friction when stopping
#		VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	
	if Input.is_action_just_released("Console") and Global.player_in_menu == false: # konsooli nähtavuse määramine
		#$CanvasLayer/Console.visible = !$CanvasLayer/Console.visible
		$CanvasLayer/Console.show()
		$CanvasLayer/Console.grab_focus()

	
	if Input.is_action_just_released("Close") and console_focus == true:
		close_console()
	
	#if Input.is_action_just_released("Close") and $CanvasLayer/Welcome_Text.visible == true: # ei tööta iga kord
		#$CanvasLayer/Welcome_Text.visible = false
		#Global.player_in_menu = false
		#welcome_text_close = false
		#ui_visibility(true)
		#
		#$CanvasLayer/keybind_start_help.visible = true
		#$CanvasLayer/keybind_start_help/VBoxContainer/moving.visible = true
		#$CanvasLayer/keybind_start_help/VBoxContainer/zooming.visible = true

	if Global.player_in_menu == false and console_focus == false and inside_a_locker == false: # liikumine lubatud ainult siis, kui mängija pole menüüs ja kui konsooli kast pole fookuses ja kui ta pole kapi sees
		set_velocity(VELOCITY)
		move_and_slide()
		#move_and_collide(VELOCITY)
	
	
	if Input.is_action_just_released("F3"):
		$CanvasLayer/debug_menu.visible = !$CanvasLayer/debug_menu.visible
	
	if Input.is_action_just_released("mb_middle") and Global.click_tp == true:
		position = get_global_mouse_position()
	
	
	
	# Rongi ajal mängija liikumine
	if Global.world_name == "MOBO" and Global.train_driving == true and (input_vector.x == 0 or input_vector.y < 0):#(input_vector.x < 0 and input_vector.y < 0) or input_vector.x > 0 and input_vector.y < 0):
		VELOCITY = VELOCITY.move_toward(Vector2(0, 1) * MAX_SPEED, ACCELERATION * delta)
		#print("yES: ", input_vector.x)
	#else:
	#	print("nO: ", input_vector.x)
	
	elif input_vector.x == 0 and input_vector.y == 0 and Global.player_in_menu == false:
		#idle_Anim()
		$AnimationPlayer.play("RESET") # lähtesta animatsioonis muudetud sõlmede väärtused
		VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)
		
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stop()
			#print("stop playngin")
	
	else: # liikumine
		VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) 
		
		if $AnimationPlayer.animation_finished: # kui animatsioon on lõpuni mänginud
			$AnimationPlayer.play("walk")
		
		if $CanvasLayer/keybind_start_help/VBoxContainer/moving.visible == true:
			$CanvasLayer/keybind_start_help/VBoxContainer/moving.visible = false
			if $CanvasLayer/keybind_start_help/VBoxContainer/zooming.visible == false:
				$AnimationPlayer3.play("more_keybinds")
		
		if $AudioStreamPlayer2D.stream != walk_sfx and Global.world_name == "MOBO":
			$AudioStreamPlayer2D.stream = walk_sfx
		if $AudioStreamPlayer2D.stream != walk2_sfx and (Global.world_name == "SSD" or Global.world_name == "RAM" or Global.world_name == "CPU"):
			$AudioStreamPlayer2D.stream = walk2_sfx
		
		
		if $AudioStreamPlayer2D.playing == false and Global.player_in_menu == false and console_focus == false and inside_a_locker == false and Global.train_driving == false:
			$AudioStreamPlayer2D.play()
		
		if Global.player_in_menu == false and console_focus == false:
			
			
			if input_vector.x > 0:  # paremale liikumise puhul
				$skeleton.scale.x = 1 # mängutegelase keha on pööratud paremale
				$"skeleton/player-body/Label".scale.x = 0.57 # heart beat label
				$"skeleton/player-body/Label".position.x = -2.7 #

				if $"skeleton/player-arm2".get_child_count() >= 2:
					$"skeleton/player-arm2".get_child(1).scale.x = 1
				####if velocity.x > 30: # stop anim if 'walking into wall'(velocity 30 then)
	
			
			elif input_vector.x < 0:  #  vasakule liikumise puhul
				$skeleton.scale.x = -1 # mängutegelase keha on pööratud vasakule
				$"skeleton/player-body/Label".scale.x = -0.57 # heart beat label
				$"skeleton/player-body/Label".position.x = 1.7 #
				if $"skeleton/player-arm2".get_child_count() >= 2:
					$"skeleton/player-arm2".get_child(1).scale.x = -1
					

	# map indocator
	if Global.world_name == "MOBO":
		mapinicator_pos0 = 142.5 + (Global.player_position.x / 9) 
		mapinicator_pos1 = 286 + (Global.player_position.x / 2.8) 
		mapinicator_pos2 = 171.7 + (Global.player_position.x / 26.8)
		mapinicator_pos3 = 177.5 + (Global.player_position.x / 26.8)
		if mapinicator_pos0 >= 52.8  and mapinicator_pos0 <= 77.5: # start --- SSD
			$CanvasLayer/map/MapIndicator.position.x = mapinicator_pos0
		if mapinicator_pos1 >= 84.9 and mapinicator_pos1 <= 158.66: # SSD --- RAM
			$CanvasLayer/map/MapIndicator.position.x = mapinicator_pos1
		if mapinicator_pos2 >= 165.92 and mapinicator_pos2 <= 239.81: # RAM --- CPU #1) 165.89
			$CanvasLayer/map/MapIndicator.position.x = mapinicator_pos2
		if mapinicator_pos2 >= 241.12 and mapinicator_pos2 <= 278:
			$CanvasLayer/map/MapIndicator.position.x = mapinicator_pos3
		#print(mapinicator_pos2)
	
	if Global.world_name == "SSD":
		$CanvasLayer/map/MapIndicator.position.x = 81.365
	if Global.world_name == "RAM":
		$CanvasLayer/map/MapIndicator.position.x = 162.365
	if Global.world_name == "CPU":
		$CanvasLayer/map/MapIndicator.position.x = 243.365
	
	
	
	
	# käeshoitava asja informatsion ekraanil
	if Global.player_holding_item == true:
		if Global.world_name == "MOBO" and Global.train_driving == true and Global._train.doors_open == false:
			hide_holding_item_info()
		else:
			show_holding_item_info()
	else:
		hide_holding_item_info()
	


	$CanvasLayer/debug_menu.text = str("WORLD: ",Global._world,"\nPOS: ",position.round(),"\nPOS(locker): ",player_pos_int,"\nitem_name: ",Global.item_name,"\nbox_item: ",Global.box_item,"\nunique_item_id: ",Global.unique_item_id,"\nholding_item_name: ",Global.holding_item_name,"\nMOBO_box_item_list: ",Global.MOBO_box_item_list,"\ntask_menu_info_dict: ",Global.task_menu_info_dict,"\ninput_vector: ",input_vector) # info ekraanil
	$CanvasLayer/debug_menu/debug_menu2.text = str("Global." + Global.world_name + "_item_id_list: ", Global.get(Global.world_name + "_item_id_list"), "\nGlobal." + Global.world_name + "_item_name_list: ", Global.get(Global.world_name + "_item_name_list"), "\nGlobal." + Global.world_name + "_item_position_list: ", Global.get(Global.world_name + "_item_position_list"), "\nGlobal." + Global.world_name + "_box_item_list: ", Global.get(Global.world_name + "_box_item_list"))
	
	
	

func show_holding_item_info(): #if "Android" in OS.get_name():
	# tekstid
	item_info.text = Global.item_name
	
	if "box1" in Global.holding_item_name: 
		if Global.box_item != null:
			item_info.text = Global.box_item
		else:
			item_info.text = Global.item_name
		
		interact_f_label.show() #[F] pane maha
		interact_g_label2.hide() #[G] pane kasti
		if Global.in_BoxOpening_area == true:
			interact_g_label.show() #[G] ava
		else:
			interact_g_label.hide() #[G] ava
	
	elif Global.holding_item_name == "box2":
		if Global.language == "english" or Global.language == "skibidi":
			item_info.text = "empty box"
		else:
			item_info.text = "tühi kast"
		interact_f_label.show() #[F] pane maha
		interact_g_label.hide() #[G] ava
		if Global.in_pickup_area == true and Global.in_item_area != "box1" and Global.in_item_area != "box2" and Global.in_BoxOpening_area == true:
			interact_g_label2.show() #[G] pane kasti
		else:
			interact_g_label2.hide() #[G] pane kasti
	else:
		if "kapi_kood" in Global.item_name and (Global.language == "english" or Global.language == "skibidi"):
			item_info.text = Global.item_name.replace("kapi_kood", "locker_code")
		if "kapi_kood1" in Global.item_name:
			if Global.language == "english" or Global.language == "skibidi":
				item_info.text = Global.holding_item_name.replace("kapi_kood", "locker_code")
			else:
				item_info.text = Global.holding_item_name
		if "kood - " in Global.item_name and (Global.language == "english" or Global.language == "skibidi"):
			item_info.text = Global.item_name.replace("kood - ", "code - ")
		if "redel" in Global.item_name and (Global.language == "english" or Global.language == "skibidi"):
			item_info.text = "ladder"
		
		interact_f_label.show() #[F] pane maha
		interact_g_label.hide() #[G] ava
		interact_g_label2.hide() #[G] pane kasti
	
	if Global.holding_item_name == "egg.exe":
		interact_f_label.show() #[F] pane maha
		interact_g_label2.hide() #[G] pane kasti
		interact_v_label.show() #[V] viska
	else:
		interact_v_label.hide()
		
	
	if ".file" in Global.item_name:
		item_info.text = Global.item_name.replace(".file", "")
	if Global.box_item != null and ".file" in Global.box_item:
		item_info.text = Global.box_item.replace(".file", "")
		
	
	$CanvasLayer/holding_item_info.show()
	
	# labelite värvi muutused üles korjamisel 
	if Input.is_action_pressed("Interact_f"):
		interact_f_label.modulate = "00ff47"
	else:
		interact_f_label.modulate = "ffffff"
	
	if Input.is_action_pressed("Open_g"):
		interact_g_label.modulate = "00ff47"
		interact_g_label2.modulate = "00ff47"
	else:
		interact_g_label.modulate = "ffffff"
		interact_g_label2.modulate = "ffffff"
	
	if Input.is_action_pressed("Throw_v"):
		interact_v_label.modulate = "00ff47"
	else:
		interact_v_label.modulate = "ffffff"
		
	
	# jooned
	if $skeleton.scale.x == 1:
		$CanvasLayer/holding_item_info/info_line1.show()
		$CanvasLayer/holding_item_info/info_line2.hide()
	if $skeleton.scale.x == -1:
		$CanvasLayer/holding_item_info/info_line1.hide()
		$CanvasLayer/holding_item_info/info_line2.show()


func hide_holding_item_info():
	$CanvasLayer/holding_item_info.hide()
	$CanvasLayer/holding_item_info/info_line1.hide()
	$CanvasLayer/holding_item_info/info_line2.hide()
	
	if interact_f_label != null:
		interact_f_label.hide() #[F] pane maha
		interact_g_label.hide() #[G] ava
		interact_g_label2.hide() #[G] pane kasti

#func apply_acceleration(amount):
#	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
#	#VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

#func apply_friction():
#	velocity.x = move_toward(velocity.x, 0, FRICTION)
#	#VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)


#var player_holding_item
var item_sprite = Sprite2D.new()

#@onready var gloabb = load("res://Global.gd")
#var item = load("res://world/item.gd")
var opening_box

func hold_item(item_name, silet = false): ## eseme käes hoidmine
	if Global.player_holding_item == true: # kui on käes juba midagi, siis pane maha
		Global.spawn_item(item_name, position, Global.box_item)
	else:
		if Global.player_in_menu == false and silet == false:
			AudioPlayer.play_fx("res://audio/pick_up.wav")
		#if "task_item" in item_name: ############
			#item_name = item_name.split(" ")[len(item_name.split(" "))-1]
		Global.item_name = item_name
		print("◻ <PLAYER> Hold item: ", item_name)
		Global.player_holding_item = true
		Global.holding_item_name = item_name
		$"skeleton/player-arm2".add_child(item_sprite)
		#item_sprite.set_texture(load("res://world/" + item_name + ".png"))
		
		# TEXTURE
		var item_name_split = item_name.split(".")
		var item_name_end = item_name_split[len(item_name_split)-1]
		var file_type = item_name_end
		if file_type == "exe":
			file_type = item_name
		if ResourceLoader.exists("res://world/" + file_type + ".png"):
			item_sprite.texture = load("res://world/" + file_type + ".png")
		else:
			if item_name_end == "exe":
				item_sprite.texture = load("res://world/exe.png")
			else:
				item_sprite.texture = load("res://world/item.png")
			
		
		if "kood" in item_name:
			item_sprite.texture = load("res://world/kapi_kood.png")
		if "kapi_kood1" in item_name:
			Global.holding_item_name = "kapi_kood " + item_name.split(" ")[1]
		elif opening_box != true:
			Global.despawn_item(item_name)
		opening_box = false
				
		if "task_item" in item_name:
			item_sprite.texture = load("res://world/" + item_name.split(" ")[0] + ".png")
		elif  "info" in item_name:
			item_sprite.texture = load("res://world/umbrik.png")
		
		#if Global.box_item != null and ".file" in item_name:
		#	print("👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦲👨‍🦲👨‍🦲👨‍🦲👨‍🦲👵👵👵👵👵👵👵👵👵👵👵")
		#	item_info.text = "👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦱👨‍🦲👨‍🦲👨‍🦲👨‍🦲👨‍🦲👵👵👵👵👵👵👵👵👵👵👵"
		#	#item_info.text = Global.box_item.replace(".file", "")
		#	item_sprite.texture = load("res://world/file.png")
		
		
		if item_name == "redel":
			item_sprite.offset.y = -48.071
			if Global._world != null and Global.world_name != null:
				Ladder.delete_ladder_poly(Global._world.get_node("ladder_poly"), Global._world.get_node("Ladder_wall/wall_collision"))
		else:
			item_sprite.offset.y = 0
		
		if item_name == "box1" and Global.box_item == "redel":
			item_sprite.texture = load("res://world/redel_box.png")
			item_sprite.offset.y = -48.071
		
		if item_name == "egg.exe":
			item_sprite.texture = load("res://world/easteregg_hand.png")
	

func release_item(item_name, box_item, throw_item = false): ## eseme eemaldamine käest
	print("◻ <PLAYER> Release item: ", item_name)
	Global.player_holding_item = false
	Global.holding_item_name = null
	Global.item_name = null
	Global.box_item = null
	$"skeleton/player-arm2".remove_child(item_sprite)
	if item_name != null and throw_item == false:
		AudioPlayer.play_fx("res://audio/place_down.wav")
		Global.spawn_item(item_name, position, box_item)
	elif item_name != null and throw_item == true:
		Global.spawn_item(item_name, position, box_item, "throw_egg")

func refresh_item(item_name, box_item): ## eseme värskendamine käes (jookseb player stseeni sisenemisel)
	print("◻ <PLAYER> Refresh item:'", item_name)
	if Global.player_holding_item == true:
		#Global.holding_item_name = item_name
		Global.player_holding_item = false
		hold_item(item_name, true)
	else:
		if item_name != null and box_item != null:
			release_item(item_name, box_item)

func open_box(box_item): # kasti avamine
	print("◻ <PLAYER> Open box: ", Global.item_name, " → ", box_item)
	# subtask thing
	if Global.box_item == Global.deliver_ram_item and Global.subtask == 1:
		Global._task_bar.next_subtask()
	
	Global.item_name = Global.box_item
	Global.player_holding_item = false
	opening_box = true
	if box_item != null:
		hold_item(box_item)
	else:
		$"skeleton/player-arm2".remove_child($"skeleton/player-arm2".get_child(1))
	Global.spawn_item("box2", position, box_item)


func store_box():
	# subtask thing
	if "RAM-task" in Global.task_ongoing and Global.in_item_area == str(Global.deliver_ram_item):# + " info"):
		Global.task_ongoing_block.complete_ram_task()
	
	print("◻ <PLAYER> Store box: ", Global.in_item_area, " → box1")
	if Global.in_item_area != "box1" and Global.in_item_area != "box2":
		#if Global.in_item_area == "redel":
		#	Global.PopUpText("bruh", "player", Vector2.ZERO)
			
		#else:
		print("store2")
		
		Global.despawn_item(Global.in_item_area)
		Global.box_item = Global.in_item_area
		Global.holding_item_name = "box1"
		Global.item_name = "box1"
		item_sprite.texture = load("res://world/box1.png")
		$"skeleton/player-arm2".add_child(item_sprite)
		if Global.in_item_area == "redel":
			item_sprite.texture = load("res://world/redel_box.png")
			item_sprite.offset.y = -48.071


func throw_item():
	release_item(Global.item_name, Global.box_item, true)


func inside_locker(inside_state):
	inside_a_locker = inside_state
	if inside_state == true:
		position = Vector2(player_pos_int.x *7.5 + 3.5, player_pos_int.y *7.5 + 4.8)
		self.hide()
		$CollisionShape2D.disabled = true
		#####Global.items_in_lockers.append(self)
	else:
		self.show()
		$CollisionShape2D.disabled = false
		#####Global.items_in_lockers.erase(self)

# animatsioonid

func idle_Anim():
	#print("idle")
	$AnimationPlayer.play("RESET")
	#hand1.rotation = move_toward(hand1.rotation , 0, 0.1) # hand1 liigub sujuvalt tavalisse rotatsiooni
	#hand2.rotation = move_toward(hand2.rotation, 0, 0.1) # hand2 liigub sujuvalt tavalisse rotatsiooni
	#leg1_pos.position.y = move_toward(leg1_pos.position.y, 6.3, 0.2) # leg1 liigub sujuvalt tavalisse positsiooni
	#leg2_pos.position.y = move_toward(leg2_pos.position.y, 6.3, 0.2) # leg1 liigub sujuvalt tavalisse positsiooni

#		animatedSprite.animation = "Idle"
	##leg1_pos_switch = false
	##leg2_pos_switch = true

func walking_HandsAnim():
	pass
	#if hand1.rotation_degrees < -14.6:
		#hand1_rotation_switch = true
		#
	#if hand1.rotation_degrees > 14.6:
		#hand1_rotation_switch = false
		#
	#if hand1_rotation_switch == true:
		#hand1.rotation_degrees += 2
	#if hand1_rotation_switch == false:
		#hand1.rotation_degrees += -2
		#
		#
	#if hand2.rotation_degrees < -14.9:
		#hand2_rotation_switch = true
		#
	#if hand2.rotation_degrees > 14.9:
		#hand2_rotation_switch = false
		#
	#if hand2_rotation_switch == true:
		#hand2.rotation_degrees += 2
	#if hand2_rotation_switch == false:
		#hand2.rotation_degrees += -2

func walking_LegsAnim(): #
	if $AnimationPlayer.animation_finished:
		$AnimationPlayer.play("walk")
	#if leg1_pos.position.y < 5:
		#leg1_pos_switch = true
		#
	#if leg1_pos.position.y > 6.1:
		#leg1_pos_switch = false
		#
	#if leg1_pos_switch == true:
		#leg2_pos_switch = false
		#leg1_pos.position.y += 0.07
	#if leg1_pos_switch == false:
		#leg1_pos.position.y += -0.07
#
#
	#if leg2_pos.position.y < 5:
		#leg2_pos_switch = true
		#
	#if leg2_pos.position.y > 6.1:
		#leg2_pos_switch = false
		#
	#if leg2_pos_switch == true:
		#leg1_pos_switch = false
		#leg2_pos.position.y += 0.07
	#if leg2_pos_switch == false:
		#leg2_pos.position.y += -0.07
	


	


#func blink_Anim():
	##print("blin time: ", blink_time)
	#blink_time += -0.1
	#if blink_time < 0:
		#$"player/player-skeleton/eyes-closed".visible = true
		#$"player/player-eyes/eyes".visible = false
		#if blink_time < -1:
			#$"player/player-skeleton/eyes-closed".visible = false
			#$"player/player-eyes/eyes".visible = true
			#blink_time = rng.randf_range(0, 20)
			#rng.randomize()



func _on_console_focus_entered():
	console_focus = true
	if "Android" in OS.get_name() and DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('') # android keyboard
		$CanvasLayer/Console.position.y = 36


func close_console():
	$CanvasLayer/Console.release_focus()
	$CanvasLayer/Console.hide()
	console_focus = false
	DisplayServer.virtual_keyboard_hide() # android keyboard



# MÄNGU SISESE KONSOOLI KÄSUD
func _on_console_text_submitted(new_text):
	#print(new_text.find("skin")
	if new_text.begins_with("/skin "):  # not useful if rn
		if "/skin blue" in new_text:
			print("/skin blue")
			$skeleton.modulate = "#ffffff"
		if "/skin green" in new_text:
			print("/skin green")
			$skeleton.modulate = "#ffff00"
		if "/skin ghost" in new_text:
			print("/skin ghost")
			$skeleton.modulate = "ffffff28"
	
	elif new_text.begins_with("/noclip"):
		if new_text == "/noclip on":
				print("/noclip on")
				$CollisionShape2D.disabled = true
		if new_text == "/noclip2 on":
				print("/noclip2 on")
				set_collision_mask(4)
		if new_text == "/noclip off" or new_text == "/noclip2 off":
				print("/noclip off")
				set_collision_mask(1)
				$CollisionShape2D.disabled = false
				
	
	elif "/getpos" in new_text:
		print("Your position is: ", position)
	
	elif "/getvar" in new_text:
		#var vaartus = true
		#var test = get("vaartus")
		#
		#var temp1 = get("test")
		#set("test", temp1)
		#print("TEST: ",test)
		
		if len(new_text.split(" ")) == 2:
			var variable_str = new_text.split(" ")[1]

			print("/getvar > (Global) ", variable_str, ": ", Global.get(variable_str))
			Global.PopUpText(str("/getvar > (Global) ", variable_str, ": ", Global.get(variable_str)), "player", Vector2.ZERO)
		
			#var bob = get(new_text.split(" ")[1])
			#var bob2 = "bob"
			#
			#print(get(bob2))
	#elif "/setvar" in new_text: #####
		#if len(new_text.split(" ")) == 3:
			#var variable_name = new_text.split(" ")[1]
			#var variable_value = new_text.split(" ")[1]
			#Global.get(variable_name) = variable_value
#
			#print("/setvar > (Global) ", variable_name, " = ", variable_value)
			#Global.PopUpText(str("/setvar > (Global) ", variable_name, " = ", variable_value), "player", Vector2.ZERO)
		
		
		
			
		#for i in new_text.split(" "):
			#pass
		#for i in new_text:
			#if i != "/getvar":
				#print(new_text)
	
	elif new_text.begins_with("/itemlist "):
		if "/itemlist mobo" in new_text:
			print("MOBO_item_name_list: ",Global.MOBO_item_name_list)
		if "/itemlist cpu" in new_text:
			print("CPU_item_name_list: ",Global.CPU_item_name_list)
		if "/itemlist ssd" in new_text:
			print("SSD_item_name_list: ",Global.SSD_item_name_list)
	
	elif new_text.begins_with("/newtask"):
		var new_task_name = new_text.split(" ")[len(new_text.split(" "))-1]
		Global._task_menu.new_task(new_task_name, "new")
	
	elif new_text.begins_with("/spawn"):
		var new_text_split
		var new_text_end
		if '"' in new_text:
			print("-🚙🚙🚙new_text_split - ", new_text_split)
			new_text_split = new_text.split('"')
			new_text_end = new_text_split[len(new_text_split)-2]
		else:
			print("🚚🚚🚚new_text_split - ", new_text_split)
			new_text_split = new_text.split(" ")
			new_text_end = new_text_split[len(new_text_split)-1]
		
		if "|" in new_text_end:
			new_text_end = new_text_end.replace("|", " ")
		Global.spawn_item(new_text_end, position, new_text_end)
	
	elif new_text.begins_with("/points"):
		var new_text_split = new_text.split(" ")
		Global.player_task_level_points = int(new_text_split[len(new_text_split)-1])
		points_particles()
	
	elif new_text.begins_with("/despawn"):
		if new_text == "/despawn":
			release_item(null, null)
		if new_text == "/despawn all":
			for el in Global.item_bodies_list:
				el.despawning(true)
				print(Global.item_bodies_list)
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
	
	elif new_text.begins_with("/duplicate"):
		if Global.item_name != null:
			Global.spawn_item(Global.item_name, position, Global.box_item)
	
	elif new_text.begins_with("/store"):
		store_box()
	elif new_text.begins_with("/open"):
		open_box(Global.box_item)
	
	elif new_text.begins_with("/newtaskbtn"):
		Global._task_menu.toggle_newtask_btn()
	
	elif new_text.begins_with("/reload"):
		if "full" not in new_text:
			Global.scene_savepos = position
		get_tree().reload_current_scene()
		print("reloading...")
	
	elif new_text.begins_with("/removescene"):
		var reload_scene_name = new_text.split(" ")[len(new_text.split(" "))-1]
		var reload_scene = Global.get(reload_scene_name)
		reload_scene.queue_free()
		print("removing scene - ", reload_scene)
	
	elif new_text.begins_with("/tp"):
		if "on" in new_text:
			Global.click_tp = true
		elif "off" in new_text:
			Global.click_tp = false
	
	elif new_text.begins_with("/feedback"):
		$CanvasLayer/feedback_menu.visible = true
		Global.player_in_menu = true
	
	elif new_text.begins_with("/filetest"):
		if "wav" in new_text:
			#if FileAccess.file_exists("res://audio/computer_success.wav"):
			if ResourceLoader.exists("res://audio/computer_success.wav"):
				$AudioStreamPlayer2D2.stream = load("res://audio/computer_success.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("YES!", "player", Vector2.ZERO)
			else:
				$AudioStreamPlayer2D2.stream = load("res://audio/beep_bad.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("NO!", "player", Vector2.ZERO)
		
		elif "txt" in new_text:
			if FileAccess.file_exists("res://world/files.txt"):
				$AudioStreamPlayer2D2.stream = load("res://audio/computer_success.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("YES!", "player", Vector2.ZERO)
			else:
				$AudioStreamPlayer2D2.stream = load("res://audio/beep_bad.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("NO!", "player", Vector2.ZERO)
		
		elif "png" in new_text:
			if ResourceLoader.exists("res://world/png.png"):
				$AudioStreamPlayer2D2.stream = load("res://audio/computer_success.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("YES!", "player", Vector2.ZERO)
			else:
				$AudioStreamPlayer2D2.stream = load("res://audio/beep_bad.wav")
				$AudioStreamPlayer2D2.play()
				Global.PopUpText("NO!", "player", Vector2.ZERO)
	
	elif new_text.begins_with("/whatos"):
		Global.PopUpText(str(OS.get_name()), "player", Vector2.ZERO)
		if "Android" in OS.get_name():
			$AudioStreamPlayer2D2.stream = load("res://audio/computer_success.wav")
			$AudioStreamPlayer2D2.play()
	
	elif new_text.begins_with("/show"):
		if "android" in new_text:
			$CanvasLayer/Movement.visible = true
			keyb_btn.visible = false
	
	
	#if new_text.begins_with("/speed "):
	#	MAX_SPEED = int(new_text.ends_with(TYPE_INT))
	else:
		print("Unknown command!")
	$CanvasLayer/Console.text = ""
	close_console()



func _on_pause_btn_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	Global._pause_menu.show_pause_menu()

var task_menu_open = false
var helparrow_added = false
# ÜLESANNETE PANEEL
func _on_task_btn_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	if Global.player_in_menu == false:
		task_menu_open = !task_menu_open
		task_menu.visible = !task_menu.visible
		task_bar.visible = !task_bar.visible
		
		if "task1" not in Global.showed_helparrow and $CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow.visible == true:
			Global.showed_helparrow.append("task1")
			$CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow.visible = false
		
		#if Global.helparrow_state == "task":
			#Global.remove_HelpArrow(task_btn)
		#if Global.helparrow_state == "taskblock" and helparrow_added == false:
			#helparrow_added = true
			#Global.add_HelpArrow(task_menu, Vector2(-4, 40), 1)
		#if Global.helparrow_state == "done_1st_task" and Global.task_ssd_done != "":
			#helparrow_added = false
			#Global.remove_HelpArrow(task_btn)
		#if Global.helparrow_state == "done_1st_taskblock" and helparrow_added == false:
			#helparrow_added = true
			#Global.add_HelpArrow(task_menu, Vector2(-4, 40), 1)


func _on_keyb_btn_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	$CanvasLayer/keyboard_inputs.visible = !$CanvasLayer/keyboard_inputs.visible



func points_particles():
	$CanvasLayer/PointsParticles.emitting = true
 


func lang_estonian():
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label2.text = str(Global.player_task_level_points)
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label1.text = "PUNKTID:"

func lang_english():
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label2.text = str(Global.player_task_level_points)
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label1.text = "POINTS:"
	
	# start tutorial stuff
	$CanvasLayer/Welcome_Text/PanelContainer/VBoxContainer/Label.text = "Welcome"
	$CanvasLayer/Welcome_Text/PanelContainer/VBoxContainer/Label2.text = "Welcome to Bitman's homeland, Bitland - the inside of a computer, where by wandering around and solving various tasks, you will learn, among other things, what a bit is and why it is important to understand the computer's work. While adventuring in Bitland, you will also get to know the different parts (Bitland houses) that make up the inside of a computer and what these parts are needed for.\nEnjoy your journey!"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label.text = "Move with"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label3.text = "or"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label4.text = "arrow keys"
	$CanvasLayer/keybind_start_help/VBoxContainer/zooming/Label.text = "Zoom the camera with the"
	$CanvasLayer/keybind_start_help/VBoxContainer/zooming/Label2.text = "scrollwheel"
	$CanvasLayer/keybind_start_help/Label.text = "More info here"
	
	# keybind texts
	$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.text = "[F] put down"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_f_label.text = "put down"
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.text = "[G] open"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label.text = "open"
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.text = "[G] store"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label2.text = "store"
	
	# keybinds help menu
	$CanvasLayer/keyboard_inputs/liikumis_klabel.text = "Movement"
	$CanvasLayer/keyboard_inputs/esemed_klabel.text = "Item actions"
	$CanvasLayer/keyboard_inputs/uldised_klabel.text = "General actions"
	$CanvasLayer/keyboard_inputs/liikumisk.text = "W  -  up\nA  -  left\nS  -  down\nD  -  right\n(or arrow keys)"
	$CanvasLayer/keyboard_inputs/esemedk.text = "F  -  pick up / put down\nG  -  open / store"
	$CanvasLayer/keyboard_inputs/uldisedk.text = "E  -  interact\nESC  -  close window / pause\nLeft mouse button  -  open / close lockers\nScrollwheel  -  camera zoom"
	


func lang_skibidi():
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label2.text = skibidi_points
	$CanvasLayer/Buttons/Points/HBoxContainer/points_label1.text = "SKIBIDI RIZZ:"
	
	# start tutorial stuff
	$CanvasLayer/Welcome_Text/PanelContainer/VBoxContainer/Label.text = "Welcome"
	$CanvasLayer/Welcome_Text/PanelContainer/VBoxContainer/Label2.text = "Welcome to Bitman's homeland, Bitland - the inside of a computer, where by wandering around and solving various tasks, you will learn, among other things, what a bit is and why it is important to understand the computer's work. While adventuring in Bitland, you will also get to know the different parts (Bitland houses) that make up the inside of a computer and what these parts are needed for.\nEnjoy your journey!"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label.text = "Move with"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label3.text = "or"
	$CanvasLayer/keybind_start_help/VBoxContainer/moving/Label4.text = "arrow keys"
	$CanvasLayer/keybind_start_help/VBoxContainer/zooming/Label.text = "Zoom the camera with the"
	$CanvasLayer/keybind_start_help/VBoxContainer/zooming/Label2.text = "scrollwheel"
	$CanvasLayer/keybind_start_help/Label.text = "More info here"
	
	# keybind texts
	$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.text = "[F] put down"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_f_label.text = "put down"
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.text = "[G] open"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label.text = "open"
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.text = "[G] store"
	$CanvasLayer/holding_item_info/InteractionLabels_android/interact_g_label2.text = "store"
	
	# keybinds help menu
	$CanvasLayer/keyboard_inputs/liikumis_klabel.text = "Movement"
	$CanvasLayer/keyboard_inputs/esemed_klabel.text = "Item actions"
	$CanvasLayer/keyboard_inputs/uldised_klabel.text = "General actions"
	$CanvasLayer/keyboard_inputs/liikumisk.text = "W  -  up\nA  -  left\nS  -  down\nD  -  right\n(or arrow keys)"
	$CanvasLayer/keyboard_inputs/esemedk.text = "F  -  pick up / put down\nG  -  open / store"
	$CanvasLayer/keyboard_inputs/uldisedk.text = "E  -  interact\nESC  -  close window / pause\nLeft mouse button  -  open / close lockers\nScrollwheel  -  camera zoom"
	


func earned_an_achievment(achievement_name : String):
	$CanvasLayer/Achievement_popup/VBoxContainer/AchievementContainer/VBoxContainer/Achievement_name.text = Global._pause_menu.get_node("CanvasLayer/Achievements_tab/VBoxContainer/PanelContainer/ScrollContainer/list_of_achievements/" + achievement_name + "/HBoxContainer/name").text
	$AnimationPlayer3.play("achienement")


# android movement ###############!!!!!!!!!!!!!!!!
#func _on_move_right_pressed():
	#VELOCITY = VELOCITY.move_toward(Vector2(1, 0) * MAX_SPEED, ACCELERATION * delta_value)
#
#
#func _on_move_left_pressed():
	#VELOCITY = VELOCITY.move_toward(Vector2(-1, 0) * MAX_SPEED, ACCELERATION * delta_value)
#
#
#func _on_move_up_pressed():
	#VELOCITY = VELOCITY.move_toward(Vector2(0, -1) * MAX_SPEED, ACCELERATION * delta_value)
#
#
#func _on_move_down_pressed():
	#VELOCITY = VELOCITY.move_toward(Vector2(0, 1) * MAX_SPEED, ACCELERATION * delta_value)



#var android_place = false
#var android_open = false
#var android_store = false
#
#func _on_interact_place_pressed():
	#android_place = true
#
#func _on_interact_open_pressed():
	#android_open = true
#
#func _on_interact_store_pressed():
	#android_store = true


func _on_close_welcome_btn_pressed():
	AudioPlayer.play_fx("res://audio/bop2.wav")
	$CanvasLayer/Welcome_Text.visible = false
	Global.player_in_menu = false
	welcome_text_close = false
	ui_visibility(true)
	
	if "Android" in OS.get_name():
		$CanvasLayer/Movement.visible = true
	else:
		$CanvasLayer/keybind_start_help.visible = true
		$CanvasLayer/keybind_start_help/VBoxContainer/moving.visible = true
		$CanvasLayer/keybind_start_help/VBoxContainer/zooming.visible = true
	
	
func ui_visibility(state):
	$CanvasLayer/Buttons.visible = state
	$CanvasLayer/map.visible = state




