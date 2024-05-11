extends Node2D

class_name World


var _save: SaveGame

@onready var _player := $ysort/player

#var item_instance = load("res://world/item.tscn").instantiate()
#var item_gd = load("res://world/item.gd")

	

func _ready() -> void:
	Global._world = self # # Global skriptis muutuja _world määramine selleks maailmaks
	Global.world_name = self.name
	Global.most_recent_scene = self.get_tree().current_scene.scene_file_path
	#remove_children(get_node("ysort/items"))
	
	if Global.spawn_mobo_item == false: # remove manually put in items
		for el in get_node("ysort/items").get_children():
			el.queue_free()
	
	if Global.spawn_mobo_item == true:
		Global.spawn_mobo_item = false
		spawn_mobo_items()
	
	# SHADER
	Global.player_vignette.material.set("shader_param/softness", 1.25)

	# MUSIC
	#AudioPlayer.play_music_level()
	
	
	
	## GAME/SCENE STATE LOADER
	if Global.MOBO_item_name_list != []:
#
		for i in len(Global.MOBO_item_name_list):
			print(Global.MOBO_item_name_list, Global.MOBO_item_position_list, Global.MOBO_box_item_list)
			Global.spawn_item(Global.MOBO_item_name_list[i], Vector2(Global.MOBO_item_position_list[i]), Global.MOBO_box_item_list[i])
	
	Global.MOBO_item_name_list = []
	Global.MOBO_item_position_list = []
	Global.MOBO_box_item_list = []
	
	## dict
	#if Global.MOBO_items_dict != {}:
		#for el in Global.MOBO_items_dict:
			#Global.spawn_item(el, Vector2(Global.MOBO_items_dict[el]), Global.MOBO_items_dict[el])
			

## SPAWN SPECIFIC ITEMS ON FIRST RUN
func spawn_mobo_items():
	Global.spawn_item("box1", Vector2(213,145), "empty")



#
#func _create_or_load_save() -> void:
	#if SaveGame.save_exists():
		##print("a save exists")
		#_save = SaveGame.load_savegame() as SaveGame
	#else:
		##print("writing save")
		#_save = SaveGame.new()
		#
		#_save.global_position =_player.global_position
		#
		#_save.write_savegame()
#
	#_player.global_position = _save.global_position
	

func save_all_items():
	#print($ysort/items.get_children())
	for i in $ysort/items.get_children():
		i.save_item()





#------------------------...delete...

#func _process(delta):
	#if Global.save_items == true:
		#print($ysort.get_node("items")
		#Global.save_items = false
		#.save_item()
	
	
	

	#if Global.spawn_item == true:
		#spawn_item()
	#if Global.despawn_item == true:
		#despawn_item()
	#
	##### PICK UP ITEMS #--->#
	#if player_holding_item == false && Global.in_pickup_area == true && Input.is_action_just_released("Interact_e"):
		#print("picking up")
		#_player.hold_item()
		#
	#elif player_holding_item == true && Input.is_action_just_released("Interact_e"):
		#print("throwing down")
		#_player.release_item()
#
#
#var item_instance = load("res://world/item.tscn").instantiate()
#
#func spawn_item():
	#print("WORLD: spawning item")
	#self.add_child(item_instance)
	#item_instance.set_position(Global.player_position)
	#Global.spawn_item = false
#
#func despawn_item():
	#print("WORLD: despawning item")
	##self.remove_child(item_instance)
	#Global.despawn_item = false
	#remove_child(get_node("item"))
	
###### item ########################################################################	


##var player_instance = load("res://player/player.tscn").instantiate()
#var item_texture1 = load("res://world/gray-tile.png")
#var item_sprite = Sprite2D.new()
#
#func pick_up_item():
	#player_holding_item = true
	##print(body.get_node("skeleton/player-arm2"))
	#$Node2D/player.get_node("skeleton/player-arm2").add_child(item_sprite)
	#item_sprite.texture = item_texture1
	#Global.despawn_item = true
	#
#func throw_down_item():
	#player_holding_item = false
	##print(body.get_node("skeleton/player-arm2"))
	#$Node2D/player.get_node("skeleton/player-arm2").remove_child(item_sprite)
	#Global.spawn_item = true
###	world.spawn_item()
