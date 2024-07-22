extends Area2D
class_name Item

@export var item_name = ""
@export var box_item = ""
var item_id : int
#var delivered_to_ram #####
@export var saving = true

var self_body

var stacked = false
var stacked_inlocker = false

var item_pos_resize
var item_pos_int
#var item_pos_resize2 ###
#var item_pos_int2 ###
var item_pos_resize3
var item_pos_int3

@onready var ladder_gd = load("res://world/ladder.gd")

var pickup_label

func _ready():
	Global.unique_item_id += 1
	item_id = Global.unique_item_id
	Global.item_bodies_list.append(self)
	if Global.can_save_world_items == true:
		Global.save_world_items() ####################
	
	
	if item_name != "":
		#print(error_string(FileAccess.get_open_error()))
		
		# TEXTURE
		var item_name_split = item_name.split(".")
		var item_name_end = item_name_split[len(item_name_split)-1]
		var file_type = item_name_end
		if file_type == "exe":
			file_type = item_name

		if ResourceLoader.exists("res://world/" + file_type + ".png"):
			$Icon.texture = load("res://world/" + file_type + ".png")
		else:
			if item_name_end == "exe":
				$Icon.texture = load("res://world/exe.png")
			else:
				$Icon.texture = load("res://world/item.png")
	

	
	if item_name == "redel":
		$ladder_collision_placeholder/CollisionPolygon2D.disabled = false
		if Global.player_skeleton.scale.x == 1:
			$Icon.offset.y = -67
			position.x += 2
			
			## y sort avoidance
			#$Icon.position.y += 20
			#$CollisionShape2D.position.y += 20
			#$Texts.position.y += 20
			#if Global._world != null:
				#Global._world.get_node("ysort/items/" + str(self)).position.y -= 20
		else:
			$Icon.offset.y = -67
			position.x -= 2
			
			## y sort avoidance
			#$Icon.position.y += 20
			#$CollisionShape2D.position.y += 20
			#$Texts.position.y += 20
			#if Global._world != null:
				#Global._world.get_node("ysort/items/" + str(self)).position.y -= 20
		
		if Global._world != null and Global._world.get_node("Ladder_wall/wall_collision") != null and Global._world.get_node("Ladder_wall/wall_collision_clipped") != null:
			print("... trying to ladder_gd ...")
			Ladder.create_ladder_poly(self, Global._world.get_node("Ladder_wall/wall_collision"), Global._world.get_node("Ladder_wall/wall_collision_clipped")) 
		
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
	
	if "Android" in OS.get_name():
		pickup_label = $Texts/pickup_label_android
		$Texts/name_label.position.y = -12
	else:
		pickup_label = $Texts/pickup_label
		$Texts/name_label.position.y = -11

func _process(_delta):
	#print("ITEM RESIZEpos: ",item_pos_resize)
	item_pos_resize = position/7.5
	item_pos_int = (Vector2(int(item_pos_resize.x), int(item_pos_resize.y)))
	
	#item_pos_resize2 = position/15 ###
	#item_pos_int2 = (Vector2(int(item_pos_resize2.x), int(item_pos_resize2.y)))
	
	item_pos_resize3 = position/4
	item_pos_int3 = (Vector2(int(item_pos_resize3.x), int(item_pos_resize3.y)))
	
	# pickup_label värvi muutused üles korjamisel 
	if Input.is_action_pressed("Interact_f") and Global.item_body == self:
		pickup_label.modulate = "00ff47" # roheline
	if Input.is_action_just_released("Interact_f"):
		pickup_label.modulate = "ffffff" # valge
	
	update_item_visibility()
	
	if self_body != null:
		entered_item(self_body) ### !spam!  #####
	
var inside_locker = false ###

func update_item_visibility():#mouse_pos_int
	###print("still")
	#if mouse_pos_int == item_pos_int:
	# if kapi pos == item pos ---- peaks olema 
	if item_pos_int in Global.locker_state_dict and Global.world_name == "SSD" or item_pos_int in Global.locker_state_dict2 and Global.world_name == "RAM":
		inside_locker = true
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
			#print("ITEMpOs= ", position)
			if item_name == Global.deliver_ram_item: #and delivered_to_ram != true: ##### delivering ram item
				Global.task_ram_finished = true
				#item.set_task_finished()
			self.hide()
			#exited_item(self_body)
	else:
		inside_locker = false ###
	

func set_item_name(set_the_name):
	item_name = set_the_name

func set_item_position(set_the_pos):
	self.position = set_the_pos

func set_box_item(set_the_item):
	box_item = set_the_item


#Global.player_holding_item = true
#holding_item_name == "box2"

func _on_body_entered(body):
	if body is Player:
		print("💬 <item> press [F] to pick up item: ", item_name, ", ", box_item)
		self_body = body
		
		if "box1" in item_name and box_item != null:
			$Texts/name_label.text = box_item
		elif "box1" in item_name and box_item == null:
			$Texts/name_label.text = "kast"
		elif item_name == "box2":
			$Texts/name_label.text = "tühi kast"
		else:
			$Texts/name_label.text = item_name
		$Texts/name_label.show()
		
		
		entered_item(body)

func entered_item(body):
	#if (item_pos_int in Global.locker_state_dict and Global.locker_state_dict[item_pos_int][0] == "closed") or (item_pos_int in Global.locker_state_dict2 and Global.locker_state_dict2[item_pos_int][0] == "closed"):
	if self.visible == false:
		pass
	else:
		Global.in_pickup_area = true
		Global.in_item_area = item_name
		Global.item_body = self
		
		if Global.player_holding_item == false:
			Global.item_name = item_name
			Global.box_item = box_item
			pickup_label.show()

func _on_body_exited(body):
	exited_item(body)

func exited_item(_body):
	self_body = null
	Global.in_pickup_area = false
	$Texts/name_label.hide()
	pickup_label.hide()
	
	if Global.player_holding_item == false:
		Global.item_name = null
		Global.box_item = null
	

func despawning(delete_item : bool):
	print("💢 <item> '", item_name, "'")
	Global.item_bodies_list.erase(self)
	Global.items_in_lockers.erase(self)
	if item_pos_int in Global.locker_state_dict:
		Global.locker_state_dict[item_pos_int][1] = "empty"
	if item_pos_int in Global.locker_state_dict2:
		Global.locker_state_dict2[item_pos_int][1] = "empty"
	
	# eemalda salvestatud info
	var item_id_counter = 0
	var item_id_add = true
	for el in Global.get(Global.world_name + "_item_id_list"):
		if el == item_id:
			item_id_add = false
		if item_id_add == true:
			item_id_counter += 1
	
	print(Global.get(Global.world_name + "_item_id_list"))
	print(item_id_counter)
	if item_id_counter < len(Global.get(Global.world_name + "_item_id_list")):
		
		print("🥚🥚🥚 ", str(Global.get(Global.world_name + "_item_id_list")), " --erase-- ", str(Global.get(Global.world_name + "_item_id_list")[item_id_counter]))
		Global.get(Global.world_name + "_item_id_list").erase(Global.get(Global.world_name + "_item_id_list")[item_id_counter])
		Global.get(Global.world_name + "_item_name_list").erase(Global.get(Global.world_name + "_item_name_list")[item_id_counter])
		Global.get(Global.world_name + "_item_position_list").erase(Global.get(Global.world_name + "_item_position_list")[item_id_counter])
		Global.get(Global.world_name + "_box_item_list").erase(Global.get(Global.world_name + "_box_item_list")[item_id_counter])
	
	# eemalda item stseenist
	if delete_item == true:
		self.queue_free()

func save_item():
	print("   (♻ <item> '", item_name, "')", item_id)
	Global.get(Global.world_name + "_item_id_list").append(item_id)
	Global.get(Global.world_name + "_item_name_list").append(item_name)
	Global.get(Global.world_name + "_item_position_list").append(position)
	Global.get(Global.world_name + "_box_item_list").append(box_item)
	
	
	#if Global.world_name == "world":
		#Global.MOBO_item_name_list.append(item_name)
		#Global.MOBO_item_position_list.append(position)
		#Global.MOBO_box_item_list.append(box_item)
#
	#if Global.world_name == "cpu":
		#Global.CPU_item_name_list.append(item_name)
		#Global.CPU_item_position_list.append(position)
		#Global.CPU_box_item_list.append(box_item)
#
	#if Global.world_name == "ssd":
		#Global.SSD_item_name_list.append(item_name)
		#Global.SSD_item_position_list.append(position)
		#Global.SSD_box_item_list.append(box_item)
#
	#if Global.world_name == "ram":
		#Global.RAM_item_name_list.append(item_name)
		#Global.RAM_item_position_list.append(position)
		#Global.RAM_box_item_list.append(box_item)


var stack_size = 0
var text_moved = false
# kui eseme peale pannakse teine ese, ehk kui itemi piirkonda siseneb teise itemi piirkond
func _on_area_entered(area):
	if area is Item and area.item_name != "redel" and item_name != "redel": 
		stacked = true # on üksteise peal
		stack_size += 1
		$Icon.rotation_degrees = randi_range(-20,20) # eseme keeramine, et ükteise peal olevaid esemeid paremini eristada
		if inside_locker == true: # kui ese on kapi sees
			stacked_inlocker = true # on üksteise peal kapis
		
		if area.text_moved == false:
			$Texts.position.y = -7
			text_moved = true

func _on_area_exited(area):
	if area is Item and area.item_name != "redel" and item_name != "redel":
		stack_size -= 1
		if stack_size == 0:
			stacked = false
			stacked_inlocker = false
			
			text_moved = false
			$Texts.position.y = 0
			$Icon.rotation_degrees = 0


# ladder ysort problem solver
func _on_ladder_collision_placeholder_body_entered(body):
	if body is Player:
		Global._player.z_index = 1
		print(Global._player.z_index)


func _on_ladder_collision_placeholder_body_exited(body):
	if body is Player:
		Global._player.z_index = 0
