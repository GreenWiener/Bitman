extends Node2D


func _ready():
	print("⏺ <RAM> ---------- scene loaded ---------- ⏺")
	Global._world = self
	Global.world_name = "RAM"
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path
	
	# items put in with code
	if Global.spawn_ram_item == true: 
		Global.spawn_ram_item = false
		spawn_ram_items()
	#else:
		## remove manually put in items (in the scene)
		#for el in get_node("ysort/items").get_children():
			#print("💢 <RAM> despawning all manually put in items")
			#el.despawning(false)

	
	## GAME/SCENE STATE LOADER
	Global.can_save_world_items = false
	if Global.RAM_item_name_list != []:
		for i in len(Global.RAM_item_name_list):
			if i < len(Global.RAM_item_name_list):
				Global.spawn_item(Global.RAM_item_name_list[i], Vector2(Global.RAM_item_position_list[i]), Global.RAM_box_item_list[i])
	
	Global.can_save_world_items = true
	Global.save_world_items()
	
	##Global.RAM_item_name_list = []
	##Global.RAM_item_position_list = []
	##Global.RAM_box_item_list = []
	
	# SHADER
	Global.player_vignette.material.set("shader_param/softness", 0.78)
	

## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_ram_items():
	#Global.spawn_item("box1", Vector2(397, 148), "")
	
	pass


#func save_all_items():
	##print("CHILDREN:-:-:",$ysort/items.get_children())
	#print("✅SAVING all RAM items✅")
	#for i in $ysort/items.get_children():
		#i.save_item()




### KASTI AVAMISE PIIRKOND

func _on_drop_off_area_body_entered(body):
	if body is Player:
		Global.in_BoxOpening_area = true


func _on_drop_off_area_body_exited(body):
	if body is Player:
		Global.in_BoxOpening_area = false




func _on_button_pressed():
	Global.PopUpText("AUGH", "player", Vector2.ZERO)
	#Global.spawn_item("egg.exe", $CanvasLayer/Button.position + Vector2(15,0), "egg.exe", "egg.exe")
	Global.spawn_item("egg.exe", get_global_mouse_position(), "egg.exe", "egg.exe")

func _process(delta):
	for el in Global.item_bodies_list:
		if el.easter_egg == true and el.position.y < 110:
			el.position += Vector2(0, 0.3)
			print(el.position)
