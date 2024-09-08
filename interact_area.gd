extends Area2D

@export var text = ""
@export var text_2 = ""
@export var type = ""
@export var text_pos : Vector2

@export var collision_scale : Vector2


var player
var can_open_traindoors = true

var in_interact_area = false

var interaction_label
var the_labe_text1
var the_labe_text2

func _ready():
	if "Android" in OS.get_name():
		interaction_label = $interaction_label_android
	else:
		interaction_label = $interaction_label
	
	
	$CollisionShape2D.scale = collision_scale
	
	if Global.language == "english" or Global.language == "skibidi":
		if type == "train_doors":
			text = "open doors"
			text_2 = "close doors"
		if type == "kast":
			text = "place a box"
	
	#text
	if "Android" in OS.get_name() and type != "info":
		the_labe_text1 = text
		the_labe_text2 = text_2
		interaction_label.text = the_labe_text1
	else:
		the_labe_text1 = "[E] " + text
		the_labe_text2 = "[E] " + text_2
		interaction_label.text = the_labe_text1
	
	#text position
	if text_pos == Vector2(0,0):
		interaction_label.position = Vector2(-6.707, -8.433)
	else:
		interaction_label.position = text_pos
	
	
	
func _physics_process(_delta):
	if Input.is_action_pressed("Interact_e"):
		if type == "train_start" and Global._train.doors_open == true or type == "train_start" and Global.next_train_direction == true or type == "kast" and Global.player_holding_item == false:
			interaction_label.modulate = "ff0047" # red
		else:
			interaction_label.modulate = "00ff47" # green
	else:
		interaction_label.modulate = "ffffff" #white
	
	if Input.is_action_just_released("Interact_e") and in_interact_area == true:
		
		if type == "kast" and Global.player_holding_item == true:
			print("'aseta kast'")
			AudioPlayer.play_fx("res://audio/place_down.wav")
			Global.spawn_item(Global.item_name, Vector2(100, 113), Global.box_item)
			Global._player.release_item(null, null)
			
		
		if type == "train_doors" and can_open_traindoors == true:
			print("'ava rongi uksed'")
			Global._train.interact_doors()
		
		if type == "train_start" and Global.train_driving == false:
			if Global._train.doors_open == false:
				if Global.next_train_direction == false:
					Global.train_driving = true
					interaction_label.hide()
					print("'start rong'")
					AudioPlayer.play_music_train()
					AudioPlayer.play_fx("res://audio/beep1.wav")
					AudioPlayer.play_train_noise()
					# subtask thing
					if "CPU-task" in Global.task_ongoing and Global.subtask == 1:
						Global._task_bar.next_subtask()
					
				else:
					print("Ei saa praegu sõita!")
					if Global.language == "english" or Global.language == "skibidi":
						Global.PopUpText("Can't drive at the moment!", "player", Vector2.ZERO)
					else:
						Global.PopUpText("Ei saa praegu sõita!", "player", Vector2.ZERO)
					AudioPlayer.play_fx("res://audio/beep_bad2.wav")
			else:
				print("Sulge rongi uksed enne sõitma hakkamist!")
				if Global.language == "english" or Global.language == "skibidi":
					Global.PopUpText("Close the doors!", "player", Vector2.ZERO)
				else:
					Global.PopUpText("Sulge uksed!", "player", Vector2.ZERO)
				
				AudioPlayer.play_fx("res://audio/beep_bad.wav")
	
	if type == "train_doors" and in_interact_area == true:
		if Global._train.doors_open == true:
			interaction_label.text = the_labe_text2
		else:
			interaction_label.text = the_labe_text1
		
		if Global.train_driving == false:
			can_open_traindoors = true
			interaction_label.show()
			
func _on_body_entered(body):
	if body is Player and text != "0":
		player = body
		in_interact_area = true
		interaction_label.show()
		
		if Global.train_driving == true:
			if type == "train_doors" or type == "train_start":
				interaction_label.hide()
				can_open_traindoors = false
			
func _on_body_exited(body):
	if body is Player and text != "0":
		in_interact_area = false	
		interaction_label.hide()


func _on_area_entered(area):
	if area is Item:
		if type == "kast2":
			print("item kontroll:", area)
			if (area.box_item == Global.deliver_cpu_item and Global.deliver_cpu_item != null) or area.box_item == "yes":
				##Global.task_cpu_finished = true
				print("Õige faili info!")
				AudioPlayer.play_fx("res://audio/computer_success.wav")
				Global.task_dec_num = randi_range(1, 63)
				Global.spawn_item("kood - " + str(Global.task_dec_num), Vector2(position.x - 2.5, position.y + 6), "kood - " + str(Global.task_dec_num))
				if "CPU-task" in Global.task_ongoing and (Global.subtask == -1 or Global.subtask == 3): # subtask thing
					Global._task_bar.next_subtask(4)
				$Sprite2D.frame = 2
				await get_tree().create_timer(3.0).timeout
				$Sprite2D.frame = 0
			else:
				print("Vale faili info!")
				if "CPU-task" in Global.task_ongoing and Global.subtask == -1: # subtask thing
					Global._task_bar.next_subtask(-1)
				$Sprite2D.frame = 1
				await get_tree().create_timer(3.0).timeout
				$Sprite2D.frame = 0
				print("2nfo!")
		if type == "kast3":
			print("item lõpp:", area)
			area.despawning(true)




