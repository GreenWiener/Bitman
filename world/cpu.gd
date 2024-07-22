extends Node2D


func _ready():
	print("⏺ <CPU> ---------- scene loaded ---------- ⏺")
	Global._world = self
	Global.world_name = "CPU"
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path

	# items put in with code
	if Global.spawn_cpu_item == true: 
		Global.spawn_cpu_item = false
		spawn_cpu_items()
	#else:
		## remove manually put in items (in the scene)
		#for el in get_node("ysort/items").get_children():
			#print("💢 <CPU> despawning all manually put in items")
			#el.despawning(false)

	## GAME/SCENE STATE LOADER
	Global.can_save_world_items = false
	if Global.CPU_item_name_list != []:
		for i in len(Global.CPU_item_name_list):
			if i < len(Global.CPU_item_name_list):
				Global.spawn_item(Global.CPU_item_name_list[i], Vector2(Global.CPU_item_position_list[i]), Global.CPU_box_item_list[i])
	
	Global.can_save_world_items = true
	Global.save_world_items()
	##Global.CPU_item_name_list = []
	##Global.CPU_item_position_list = []
	##Global.CPU_box_item_list = []

	# SHADER
	Global.player_vignette.material.set("shader_param/softness", 1)


## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_cpu_items():
	#Global.spawn_item("box1", Vector2(11, 143), "")
	pass

#func save_all_items():
	#print("CHILDREN:::",$ysort/items.get_children())
	#for i in $ysort/items.get_children():
		#i.save_item()

