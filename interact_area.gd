extends Area2D

@export var text = ""
@export var text_2 = ""
@export var type = ""
@export var text_pos : Vector2

@export var collision_scale : Vector2


var player
var can_open_traindoors = true

var in_interact_area = false

func _ready():
	$CollisionShape2D.scale = collision_scale
	
	#text
	if type == "info":
		$interaction_label.text = text
	else:
		$interaction_label.text = "[E] " + text
	
	#text position
	if text_pos == Vector2(0,0):
		$interaction_label.position = Vector2(-6.707, -8.433)
	else:
		$interaction_label.position = text_pos
	
func _physics_process(_delta):
	if Input.is_action_pressed("Interact_e"):
		if type == "train_start" and Global._train.doors_open == true or type == "train_start" and Global.next_train_direction == true or type == "kast" and Global.player_holding_item == false:
			$interaction_label.modulate = "ff0047" # red
		else:
			$interaction_label.modulate = "00ff47" # green
	else:
		$interaction_label.modulate = "ffffff" #white
	
	if Input.is_action_just_released("Interact_e") and in_interact_area == true:
		
		if type == "kast" and Global.player_holding_item == true:
			print("'aseta kast'")
			Global.spawn_item(Global.item_name, Vector2(100, 113), Global.box_item)
			Global._player.release_item(null, null)
		
		if type == "train_doors" and can_open_traindoors == true:
			print("'ava rongi uksed'")
			Global._train.interact_doors()
		
		if type == "train_start" and Global.train_driving == false:
			if Global._train.doors_open == false:
				if Global.next_train_direction == false:
					Global.train_driving = true
					$interaction_label.hide()
					print("'start rong'")
					AudioPlayer.play_music_train()
				else:
					print("Ei saa praegu sõita!")
					Global.PopUpText("Ei saa praegu sõita!", "player")
			else:
				print("Sulge rongi uksed enne sõitma hakkamist!")
				Global.PopUpText("Sulge uksed!", "player")
	
	if type == "train_doors" and in_interact_area == true:
		if Global._train.doors_open == true:
			$interaction_label.text = "[E] " + text_2
		else:
			$interaction_label.text = "[E] " + text
		
		if Global.train_driving == false:
			can_open_traindoors = true
			$interaction_label.show()
			
func _on_body_entered(body):
	if body is Player and text != "0":
		player = body
		in_interact_area = true
		$interaction_label.show()
		
		if Global.train_driving == true:
			if type == "train_doors" or type == "train_start":
				$interaction_label.hide()
				can_open_traindoors = false
			
func _on_body_exited(body):
	if body is Player and text != "0":
		in_interact_area = false	
		$interaction_label.hide()


func _on_area_entered(area):
	if area is Item:
		if type == "kast2":
			print("item kontroll:", area)
			if (area.box_item == Global.deliver_cpu_item and Global.deliver_cpu_item != null) or area.box_item == "yes":
				##Global.task_cpu_finished = true
				print("Õige faili info!")
				Global.task_dec_num = randi_range(1, 63)
				Global.spawn_item("kood - " + str(Global.task_dec_num), Vector2(position.x - 2.5, position.y + 6), "kood - " + str(Global.task_dec_num))
				$Sprite2D.frame = 2
				await get_tree().create_timer(3.0).timeout
				$Sprite2D.frame = 0
			else:
				print("Vale faili info!")
				$Sprite2D.frame = 1
				await get_tree().create_timer(3.0).timeout
				$Sprite2D.frame = 0
				print("2nfo!")
		if type == "kast3":
			print("item lõpp:", area)
			area.despawning()




