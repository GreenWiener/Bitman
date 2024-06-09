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

var console_focus = false
var entered_portal = false


func _ready() -> void: ## funktsioon, mis käivitub, stseen on ära laadinud
	Global._player = self # Global skriptis muutuja _player määramine mängijaks
	Global.player_skeleton = $skeleton
	Global.player_vignette = $CanvasLayer/vignette
	$CanvasLayer/vignette.show()
	self.global_position = Global.player_inital_map_position # mängija asukoht stseeni alguses
	
	refresh_item(Global.item_name, Global.box_item) # kontrollib mängija käes olevate asju

	if Global.helparrow_state == "task":
		Global.add_HelpArrow($CanvasLayer, $CanvasLayer/task_btn.position - Vector2(10,-7))
	elif Global.helparrow_state == "done_1st_task" and Global.task_ssd_done != "":
		Global.add_HelpArrow($CanvasLayer, $CanvasLayer/task_btn.position - Vector2(10,-7))


var VELOCITY = Vector2.ZERO

#@export var float_number: float = 5

@export var MAX_SPEED = 30
const ACCELERATION = 300
const FRICTION = 300


func _physics_process(delta): ## mängija omadused ja füüsika, jookseb kogu aeg, kui stseen on laetud
	Global.player_position = position # mängija asukoht Global skriptis kasutamiseks
	$CanvasLayer/Points.text = "Punktid: " + str(Global.player_task_level_points)
	$CanvasLayer/Points2.text = "               " + str(Global.player_task_level_points)
	
	#$CanvasLayer/Label.text = str("pos: ",position.round(),"\nin_pickup_area: ",Global.in_pickup_area,", ",Global.item_name,"\nplayer_holding_item: ",Global.player_holding_item,"\nholding_item_name: ",Global.holding_item_name,"\nMOBO_item_name_list: ", Global.MOBO_item_name_list,"\nMOBO_item_position_list: ", Global.MOBO_item_position_list,"\nCPU_item_name_list: ", Global.CPU_item_name_list,"\nCPU_item_position_list: ", Global.CPU_item_position_list) # info ekraanil
	$CanvasLayer/Label.text = str("WORLD: ",Global._world,"\nPOS: ",position.round(),"\nitem_name: ",Global.item_name,"\nbox_item: ",Global.box_item,"\nholding_item_name: ",Global.holding_item_name,"\nMOBO_box_item_list: ",Global.MOBO_box_item_list) # info ekraanil
	
	#print(get(bob2))
	# liikumis klahvid ja loogika
	var input_vector = Vector2.ZERO
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
		$CanvasLayer/task_menu.hide()
		print("actully thisisisi")
	if Global.player_in_menu == false and console_focus == false: # liikumine lubatud ainult siis, kui mängija pole menüüs või kui konsooli kast pole fookuses
		set_velocity(VELOCITY)
		move_and_slide()
	
	
	if Input.is_action_just_released("F3"):
		$CanvasLayer/Label.visible = !$CanvasLayer/Label.visible
	
	if Input.is_action_just_released("mb_middle"):
		position = get_global_mouse_position()
	
	
	# Rongi ajal mängija liikumine
	if Global.world_name == "world" and Global.train_driving == true and input_vector.x == 0:
		VELOCITY = VELOCITY.move_toward(Vector2(0, 1) * MAX_SPEED, ACCELERATION * delta)
		#print("yES: ", input_vector.x)
	#else:
	#	print("nO: ", input_vector.x)
	
	elif input_vector.x == 0 and input_vector.y == 0 and Global.player_in_menu == false: # kui ei liigu
		idle_Anim()
		VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)
	
	else: # liikumine
		VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
		if Global.player_in_menu == false and console_focus == false:
			
			# kehaosade liikusmi animatsioonid
			if input_vector.x > 0:  # moving right X
				$skeleton.scale.x = 1
				if $"skeleton/player-arm2".get_child_count() >= 2:
					$"skeleton/player-arm2".get_child(1).scale.x = 1
				if velocity.x > 30: # stop anim if 'walking into wall'(velocity 30 then)
					walking_HandsAnim()
					walking_LegsAnim()
			
			elif input_vector.x < 0:  # moving left X
				$skeleton.scale.x = -1
				if $"skeleton/player-arm2".get_child_count() >= 2:
					$"skeleton/player-arm2".get_child(1).scale.x = -1
				if velocity.x < -30:
					walking_HandsAnim()
					walking_LegsAnim()
			
			if input_vector.y > 30 or input_vector.y < 30:  # moving right Y
				walking_HandsAnim()
				walking_LegsAnim()



	# käeshoitava asja informatsion ekraanil
	if Global.player_holding_item == true:
		if Global.world_name == "world" and Global.train_driving == true and Global._train.doors_open == false:
			hide_holding_item_info()
		else:
			show_holding_item_info()
	else:
		hide_holding_item_info()


func show_holding_item_info():
	# tekstid
	$CanvasLayer/holding_item_info/item_info.text = Global.item_name
	
	if "box1" in Global.holding_item_name: 
		if Global.box_item != null:
			$CanvasLayer/holding_item_info/item_info.text = Global.box_item
		else:
			$CanvasLayer/holding_item_info/item_info.text = Global.item_name
		$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.show() #[F] pane maha
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.hide() #[G] pane kasti
		if Global.in_BoxOpening_area == true:
			$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.show() #[G] ava
		else:
			$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.hide() #[G] ava
	
	elif Global.holding_item_name == "box2":
		$CanvasLayer/holding_item_info/item_info.text = "tühi kast"
		$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.show() #[F] pane maha
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.hide() #[G] ava
		if Global.in_pickup_area == true and Global.in_item_area != "box1" and Global.in_item_area != "box2" and Global.in_BoxOpening_area == true:
			$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.show() #[G] pane kasti
		else:
			$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.hide() #[G] pane kasti
	else:
		if "kapi_kood1" in Global.item_name:
			$CanvasLayer/holding_item_info/item_info.text = Global.holding_item_name
		$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.show() #[F] pane maha
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.hide() #[G] ava
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.hide() #[G] pane kasti
	
	$CanvasLayer/holding_item_info.show()
	
	# labelite värvi muutused üles korjamisel 
	if Input.is_action_pressed("Interact_f"):
		$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.modulate = "00ff47"
	else:
		$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.modulate = "ffffff"
	
	if Input.is_action_pressed("Open_g"):
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.modulate = "00ff47"
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.modulate = "00ff47"
	else:
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.modulate = "ffffff"
		$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.modulate = "ffffff"
	
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
	
	$CanvasLayer/holding_item_info/InteractionLabels/interact_f_label.hide() #[F] pane maha
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label.hide() #[G] ava
	$CanvasLayer/holding_item_info/InteractionLabels/interact_g_label2.hide() #[G] pane kasti

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

func hold_item(item_name): ## eseme käes hoidmine
	if Global.player_holding_item == true: # kui on käes juba midagi, siis pane maha
		Global.spawn_item(item_name, position, Global.box_item)
	else:
		#if "task_item" in item_name: ############
			#item_name = item_name.split(" ")[len(item_name.split(" "))-1]
		Global.item_name = item_name
		print("<PLAYER>: '",item_name,"' käes hoidmine")
		Global.player_holding_item = true
		Global.holding_item_name = item_name
		$"skeleton/player-arm2".add_child(item_sprite)
		#item_sprite.set_texture(load("res://world/" + item_name + ".png"))
		if ResourceLoader.exists("res://world/" + item_name + ".png"): # TEXTURE
			item_sprite.texture = load("res://world/" + item_name + ".png")
		else:
			item_sprite.texture = load("res://world/item.png")
			
		
		if "kood" in item_name:
			item_sprite.texture = load("res://world/kapi_kood.png")
		if "kapi_kood1" in item_name:
			Global.holding_item_name = "kapi_kood " + item_name.split(" ")[1]
		elif opening_box != true:
			print("🤢🤢🤢🤢🤢🤢🤢🤢🤢")
			Global.despawn_item(item_name)
		opening_box = false
				
		if "task_item" in item_name:
			item_sprite.texture = load("res://world/" + item_name.split(" ")[0] + ".png")
		if  "info" in item_name:
			item_sprite.texture = load("res://world/umbrik.png")
		
		
		
		if item_name == "redel":
			item_sprite.offset.y = -48.071
			if Global._world != null and Global.world_name != null:
				Ladder.delete_ladder_poly(Global._world.get_node("ladder_poly"), Global._world.get_node("Ladder_wall/wall_collision"))
		else:
			item_sprite.offset.y = 0
	

func release_item(item_name, box_item): ## eseme eemaldamine käest
	print("<PLAYER>: '",item_name,"' eemaldamine käest")
	Global.player_holding_item = false
	Global.holding_item_name = null
	$"skeleton/player-arm2".remove_child(item_sprite)
	if item_name != null:
		Global.spawn_item(item_name, position, box_item)

func refresh_item(item_name, box_item): ## eseme värskendamine käes
	print("<PLAYER>:'",item_name,"' eseme värskendamine ---")
	if Global.player_holding_item == true:
		#Global.holding_item_name = item_name
		Global.player_holding_item = false
		hold_item(item_name)
	else:
		if item_name != null and box_item != null:
			release_item(item_name, box_item)

func open_box(box_item): # kasti avamine
	Global.player_holding_item = false
	opening_box = true
	if box_item != null:
		hold_item(box_item)
	else:
		$"skeleton/player-arm2".remove_child($"skeleton/player-arm2".get_child(1))
	Global.spawn_item("box2", position, box_item)


func store_box():
	print("store1")
	if Global.in_item_area != "box1" and Global.in_item_area != "box2":
		if Global.in_item_area == "redel":
			Global.PopUpText("bruh", "player")
		else:
			print("store2")
			
			Global.despawn_item(Global.in_item_area)
			Global.box_item = Global.in_item_area
			Global.holding_item_name = "box1"
			Global.item_name = "box1"
			item_sprite.texture = load("res://world/box1.png")
			$"skeleton/player-arm2".add_child(item_sprite)
	
	

# animatsioonid

func idle_Anim():
	#print("idle")
	hand1.rotation = move_toward(hand1.rotation , 0, 0.1) # hand1 liigub sujuvalt tavalisse rotatsiooni
	hand2.rotation = move_toward(hand2.rotation, 0, 0.1) # hand2 liigub sujuvalt tavalisse rotatsiooni
	leg1_pos.position.y = move_toward(leg1_pos.position.y, 6.3, 0.2) # leg1 liigub sujuvalt tavalisse positsiooni
	leg2_pos.position.y = move_toward(leg2_pos.position.y, 6.3, 0.2) # leg1 liigub sujuvalt tavalisse positsiooni

#		animatedSprite.animation = "Idle"
	##leg1_pos_switch = false
	##leg2_pos_switch = true

func walking_HandsAnim():
	if hand1.rotation_degrees < -14.6:
		hand1_rotation_switch = true
		
	if hand1.rotation_degrees > 14.6:
		hand1_rotation_switch = false
		
	if hand1_rotation_switch == true:
		hand1.rotation_degrees += 2
	if hand1_rotation_switch == false:
		hand1.rotation_degrees += -2
		
		
	if hand2.rotation_degrees < -14.9:
		hand2_rotation_switch = true
		
	if hand2.rotation_degrees > 14.9:
		hand2_rotation_switch = false
		
	if hand2_rotation_switch == true:
		hand2.rotation_degrees += 2
	if hand2_rotation_switch == false:
		hand2.rotation_degrees += -2

func walking_LegsAnim(): #
	if leg1_pos.position.y < 5:
		leg1_pos_switch = true
		
	if leg1_pos.position.y > 6.1:
		leg1_pos_switch = false
		
	if leg1_pos_switch == true:
		leg2_pos_switch = false
		leg1_pos.position.y += 0.07
	if leg1_pos_switch == false:
		leg1_pos.position.y += -0.07


	if leg2_pos.position.y < 5:
		leg2_pos_switch = true
		
	if leg2_pos.position.y > 6.1:
		leg2_pos_switch = false
		
	if leg2_pos_switch == true:
		leg1_pos_switch = false
		leg2_pos.position.y += 0.07
	if leg2_pos_switch == false:
		leg2_pos.position.y += -0.07
	


	


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


func close_console():
	$CanvasLayer/Console.release_focus()
	$CanvasLayer/Console.hide()
	console_focus = false



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
	
	elif new_text.begins_with("/noclip "):
		if new_text == "/noclip on":
				print("/noclip on")
				$CollisionShape2D.disabled = true
		if new_text == "/noclip on1":
				print("/noclip on1")
				set_collision_mask(4)
		if new_text == "/noclip off":
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
			#print("##################", variable_str)			
			#var temp = variable_str
			if get(variable_str) != null:
				print("VARIABLE(Local): ", get(variable_str))
		
			else:
				print("VARIABLE(Global): ", Global.get(variable_str))
		
			#var bob = get(new_text.split(" ")[1])
			#var bob2 = "bob"
			#
			#print(get(bob2))
		
		
		
		
			
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
		Global._task_menu.newTask()
	
	elif new_text.begins_with("/spawn"):
		var new_text_split = new_text.split(" ")
		Global.spawn_item(new_text_split[len(new_text_split)-1], position, null)
	
	elif new_text.begins_with("/points"):
		var new_text_split = new_text.split(" ")
		Global.player_task_level_points = int(new_text_split[len(new_text_split)-1])
	
	elif new_text.begins_with("/despawn"):
		release_item(null, null)
	
	elif new_text.begins_with("/duplicate"):
		if Global.item_name != null:
			Global.spawn_item(Global.item_name, position, Global.box_item)
	
	elif new_text.begins_with("/store"):
		store_box()
	
	elif new_text.begins_with("/show newtaskbtn"):	
		Global._task_menu.toggle_newtask_btn()
	
	
	#if new_text.begins_with("/speed "):
	#	MAX_SPEED = int(new_text.ends_with(TYPE_INT))
	else:
		print("Unknown command!")
	$CanvasLayer/Console.text = ""
	close_console()



func _on_pause_btn_pressed():
	Global._pause_menu.show_pause_menu()


var helparrow_added = false
# ÜLESANNETE PANEEL
func _on_task_btn_pressed():
	if Global.player_in_menu == false:
		$CanvasLayer/task_menu.visible = !$CanvasLayer/task_menu.visible
		
		if Global.helparrow_state == "task":
			Global.remove_HelpArrow($CanvasLayer)
		if Global.helparrow_state == "taskblock" and helparrow_added == false:
			helparrow_added = true
			Global.add_HelpArrow($CanvasLayer/task_menu, Vector2(215, 57.5))
		if Global.helparrow_state == "done_1st_task" and Global.task_ssd_done != "":
			helparrow_added = false
			Global.remove_HelpArrow($CanvasLayer)
		if Global.helparrow_state == "done_1st_taskblock" and helparrow_added == false:
			helparrow_added = true
			Global.add_HelpArrow($CanvasLayer/task_menu, Vector2(215, 57.5))


