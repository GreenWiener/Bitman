extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global._world = self
	Global.world_name = self.name
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path
	
	if Global.spawn_ram_item == false: # remove manually put in items
		for el in get_node("ysort/items").get_children():
			el.queue_free()
	
	if Global.spawn_ram_item == true: # items put in with code
		Global.spawn_ram_item = false
		spawn_ram_items()
	
	
	## GAME/SCENE STATE LOADER
	if Global.RAM_item_name_list != []:
		print("LOADING 'RAM' SCENE STATE")

		for i in len(Global.RAM_item_name_list):
			Global.spawn_item(Global.RAM_item_name_list[i], Vector2(Global.RAM_item_position_list[i]), Global.RAM_box_item_list[i])
	
	Global.RAM_item_name_list = []
	Global.RAM_item_position_list = []
	Global.RAM_box_item_list = []
	
	# SHADER
	Global.player_vignette.material.set("shader_param/softness", 0.78)
	

## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_ram_items():
	#Global.spawn_item("box1", Vector2(397, 148), "")
	pass


func save_all_items():
	print("CHILDREN:-:-:",$ysort/items.get_children())
	for i in $ysort/items.get_children():
		i.save_item()




### KASTI AVAMISE PIIRKOND

func _on_drop_off_area_body_entered(body):
	if body is Player:
		Global.in_BoxOpening_area = true


func _on_drop_off_area_body_exited(body):
	if body is Player:
		Global.in_BoxOpening_area = false


