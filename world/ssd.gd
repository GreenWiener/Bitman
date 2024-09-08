extends Node2D


func _ready():
	print("⏺ <SSD> ---------- scene loaded ---------- ⏺")
	Global._world = self
	Global.world_name = "SSD"
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path
	
	
	# items put in with code #####################
	if Global.spawn_ssd_item == true: 
		Global.spawn_ssd_item = false
		spawn_ssd_items()
		
	#else:
		## remove manually put in items (in the scene)
		#for el in get_node("ysort/items").get_children():
			#print("💢 <SSD> despawning all manually put in items")
			#el.despawning(false)
	
	## GAME/SCENE STATE LOADER
	Global.can_save_world_items = false
	if Global.SSD_item_name_list != []:
		for i in len(Global.SSD_item_name_list):
			if i < len(Global.SSD_item_name_list): ##no
				Global.spawn_item(Global.SSD_item_name_list[i], Vector2(Global.SSD_item_position_list[i]), Global.SSD_box_item_list[i])
	
	Global.can_save_world_items = true
	Global.save_world_items()
			
			#else:
				#if i > 0:
					#i -= 1
					#print("SSD🎇 ", Global.SSD_item_name_list, Global.SSD_item_position_list, Global.SSD_box_item_list)
					#Global.spawn_item(Global.SSD_item_name_list[i], Vector2(Global.SSD_item_position_list[i]), Global.SSD_box_item_list[i])
			
	##Global.SSD_item_name_list = []
	##Global.SSD_item_position_list = []
	##Global.SSD_box_item_list = []
	
	# SHADER
	Global.player_vignette.material.set("shader_parameter/softness", 0.78)



## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_ssd_items():
	print("🍘spawn_ssd_items🍘")
	Global.SSD_item_name_list.append("redel")
	Global.SSD_item_position_list.append(Vector2(11, 148))
	Global.SSD_box_item_list.append("")
	#Global.spawn_item("redel", Vector2(11, 148), "")
	#pass
	
#func save_all_items():
	#print("CHILDREN:-:-:",$ysort/items.get_children())
	#for i in $ysort/items.get_children():
		#i.save_item()


func _on_wall_collision_1_body_entered(body):
		print("ENTERED BOODY: ", body)



#var ladder_poly
#@onready var locker_collision = $LockerLadder_collision/StaticBody2D/locker_collision
#
#func create_ladder_poly(ladder_item):
	#ladder_poly = CollisionPolygon2D.new()
	#self.add_child(ladder_poly)
	##ladder_poly.polygon = ladder_item.position#ladder_item_poly
	#
	#ladder_poly.polygon = [ladder_item.position + Vector2(-2.2,2), ladder_item.position + Vector2(-2.2,-15), ladder_item.position + Vector2(2.2,-15), ladder_item.position + Vector2(2.2,2)]
	#
	#var clip_collision = Geometry2D.clip_polygons(locker_collision.polygon, ladder_poly.polygon)
	#$LockerLadder_collision/StaticBody2D/locker_collision_clipped.polygon = clip_collision[0]
	#locker_collision.disabled = true
	##ladder.disabled = true
#
#func delete_ladder_poly():
	#if ladder_poly != null:
		#locker_collision.disabled = false
		#ladder_poly.queue_free()
	#



