#@tool

extends Area2D

#@export var current_scene = ""
@export_file var next_scene_path = ""
@export var player_spawn_location = Vector2.ZERO

@onready var _player := $ysort/player

func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path must be set for the portal to work"
	else:
		return ""



#var _save: SaveGame

var item_instance = load("res://world/item.tscn").instantiate()
func _on_body_entered(body):
	#if current_scene == "MOBO":
	print("WORLD:::", Global._world)
	Global._world.save_all_items()
	#item_instance.save_item()
	Global.player_inital_map_position = player_spawn_location # mängija asukoha määramine
	#if get_tree().change_scene_to_file(next_scene_path) != OK: # kui muutujal next_scene_path pole väärtust
	#	print("Error: 'next_scene_path' puudub!")
	#
	#if SaveGame.save_exists():
		#print("a save exists")
		#_save = SaveGame.load_savegame() as SaveGame
	
	#if body.name == "player": # ↓sama asi, teist moodi
	if body is Player: # kui portaali alasse siseneb mängija
		StageManager.changeScene(next_scene_path)

	

