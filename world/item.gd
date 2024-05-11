extends Area2D
class_name Item

@export var item_name = ""
@export var box_item = ""

var self_body

var item_pos_resize
var item_pos_int
#var item_pos_resize2 ###
#var item_pos_int2 ###
var item_pos_resize3
var item_pos_int3

func _ready():
	Global.item_bodies_list.append(self)
	if item_name != null:
		if FileAccess.file_exists("res://world/" + item_name + ".png"):
			$Icon.texture = load("res://world/" + item_name + ".png")
		else:
			$Icon.texture = load("res://world/item.png")

	#else:
	#	$Icon.texture = load("res://world/item.png") #############################################
	
	if item_name == "redel":
		if Global.player_skeleton.scale.x == 1:
			$Icon.offset.y = -67
			position.x += 2
		else:
			$Icon.offset.y = -67
			position.x -= 2
			
		if Global.world_name == "ssd":
			Global._world.create_ladder_poly(self)
			#Global._
	else:
		$Icon.offset.y = -17.361
	
	
	if item_name == "box2":
		box_item = ""
	
	item_pos_resize = position/7.5
	item_pos_int = (Vector2(int(item_pos_resize.x), int(item_pos_resize.y)))
	
	
	# kapi sees värskendused
	update_item_visibility()
	#if Global._lockers2 != null:
	#	Global._lockers2.add_locker_labels(item_pos_int)


func _process(delta):
	#print("ITEM RESIZEpos: ",item_pos_resize)
	item_pos_resize = position/7.5
	item_pos_int = (Vector2(int(item_pos_resize.x), int(item_pos_resize.y)))
	
	#item_pos_resize2 = position/15 ###
	#item_pos_int2 = (Vector2(int(item_pos_resize2.x), int(item_pos_resize2.y)))
	
	item_pos_resize3 = position/4
	item_pos_int3 = (Vector2(int(item_pos_resize3.x), int(item_pos_resize3.y)))
	
	# pickup_label värvi muutused üles korjamisel 
	if Input.is_action_pressed("Interact_f") and Global.item_body == self:
		$pickup_label.modulate = "00ff47"
	if Input.is_action_just_released("Interact_f"):
		$pickup_label.modulate = "ffffff"
	
	update_item_visibility()
	
	if self_body != null:
		entered_item(self_body) ### !spam!  ###
	
var inside_locker = false ###

func update_item_visibility():#mouse_pos_int
	#if mouse_pos_int == item_pos_int:
	# if kapi pos == item pos ---- peaks olema 
	if item_pos_int in Global.locker_state_dict or item_pos_int in Global.locker_state_dict2:
		inside_locker = true ###
		if self not in Global.items_in_lockers:
			Global.items_in_lockers[self] = item_name
		
		# SSD lockers
		if item_pos_int in Global.locker_state_dict and Global.locker_state_dict[item_pos_int][0] == "open":
			Global.locker_state_dict[item_pos_int][1] = "full"
			position = Vector2(item_pos_int.x *7.5 + 3.5, item_pos_int.y *7.5 + 4.8)
			self.show()
			#entered_item(self_body)
		if item_pos_int in Global.locker_state_dict and Global.locker_state_dict[item_pos_int][0] == "closed":
			Global.locker_state_dict[item_pos_int][1] = "full"
			position = Vector2(item_pos_int.x *7.5 + 3.5, item_pos_int.y *7.5 + 4.8)
			self.hide()
			#exited_item(self_body)
		
		# RAM lockers
		if item_pos_int in Global.locker_state_dict2 and Global.locker_state_dict2[item_pos_int][0] == "open":
			Global.locker_state_dict2[item_pos_int][1] = "full"
			position = Vector2(item_pos_int.x *7.5 + 3.5, item_pos_int.y *7.5 + 4.8)
			self.show()
			#entered_item(self_body)
		if item_pos_int in Global.locker_state_dict2 and Global.locker_state_dict2[item_pos_int][0] == "closed":
			Global.locker_state_dict2[item_pos_int][1] = "full"
			position = Vector2(item_pos_int.x *7.5 + 3.5, item_pos_int.y *7.5 + 4.8)
			if item_name == Global.deliver_ram_item:
				Global.task_ram_finished = true
				#item.set_task_finished()
			self.hide()
			#exited_item(self_body)
	else:
		inside_locker = false ###
	

func set_item_name(set_item_name):
	item_name = set_item_name

func set_item_position(set_item_pos):
	self.position = set_item_pos

func set_box_item(set_box_item):
	box_item = set_box_item


#Global.player_holding_item = true
#holding_item_name == "box2"

func _on_body_entered(body):
	print("press [F] to pick up")
	self_body = body
	
	if "box1" in item_name and box_item != null:
		$name_label.text = box_item
	elif "box1" in item_name and box_item == null:
		$name_label.text = "kast"
	elif item_name == "box2":
		$name_label.text = "tühi kast"
	else:
		$name_label.text = item_name
	$name_label.show()
	
	
	entered_item(body)

func entered_item(body):
	if (item_pos_int in Global.locker_state_dict and Global.locker_state_dict[item_pos_int][0] == "closed") or (item_pos_int in Global.locker_state_dict2 and Global.locker_state_dict2[item_pos_int][0] == "closed"):
		pass
	else:
		Global.in_pickup_area = true
		Global.in_item_area = item_name
		Global.item_body = self
		
		if body is Player and Global.player_holding_item == false:
			Global.item_name = item_name
			Global.box_item = box_item
			$pickup_label.show()

func _on_body_exited(body):
	exited_item(body)

func exited_item(body):
	self_body = null
	Global.in_pickup_area = false
	$name_label.hide()
	$pickup_label.hide()
	
	if Global.player_holding_item == false:
		Global.item_name = null
		Global.box_item = null
	

func despawning():
	Global.item_bodies_list.erase(self)
	Global.items_in_lockers.erase(self)
	if item_pos_int in Global.locker_state_dict:
		Global.locker_state_dict[item_pos_int][1] = "empty"
	if item_pos_int in Global.locker_state_dict2:
		Global.locker_state_dict2[item_pos_int][1] = "empty"
	
	self.queue_free()

func save_item():
	if Global.world_name == "world":
		Global.MOBO_item_name_list.append(item_name)
		Global.MOBO_item_position_list.append(position)
		Global.MOBO_box_item_list.append(box_item)

	if Global.world_name == "cpu":
		Global.CPU_item_name_list.append(item_name)
		Global.CPU_item_position_list.append(position)
		Global.CPU_box_item_list.append(box_item)

	if Global.world_name == "ssd":
		Global.SSD_item_name_list.append(item_name)
		Global.SSD_item_position_list.append(position)
		Global.SSD_box_item_list.append(box_item)

	if Global.world_name == "ram":
		Global.RAM_item_name_list.append(item_name)
		Global.RAM_item_position_list.append(position)
		Global.RAM_box_item_list.append(box_item)
