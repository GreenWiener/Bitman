extends Node2D

#var lockers_instance = preload("res://world/lockers.tscn").instantiate()

func _ready():
	Global._world = self
	Global.world_name = self.name
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path

	
	if Global.spawn_cpu_item == false: # remove manually put in items
		for el in get_node("ysort/items").get_children():
			el.queue_free()

	if Global.spawn_cpu_item == true:
		Global.spawn_cpu_item = false
		spawn_cpu_items()

	## GAME/SCENE STATE LOADER
	if Global.CPU_item_name_list != []:

		for i in len(Global.CPU_item_name_list):
			Global.spawn_item(Global.CPU_item_name_list[i], Vector2(Global.CPU_item_position_list[i]), Global.CPU_box_item_list[i])
	
	Global.CPU_item_name_list = []
	Global.CPU_item_position_list = []
	Global.CPU_box_item_list = []

	# SHADER
	Global.player_vignette.material.set("shader_param/softness", 1)


## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_cpu_items():
	#Global.spawn_item("box1", Vector2(11, 143), "")
	pass

func save_all_items():
	print("CHILDREN:::",$ysort/items.get_children())
	for i in $ysort/items.get_children():
		i.save_item()

