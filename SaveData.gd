#extends Resource
#class_name SaveGame
#
#const SAVE_GAME_PATH := "res://savegame.tres"
#
##@export var player: Resource = preload("")
##@export var inventory: Resource = preload("")
#
##@export var map_name := ""
##@export var global_position := Vector2.ZERO
#@export var player_task_level_points: int = Global.player_task_level_points
#
##@export var items_in_world := []
#
#
#
#func write_savegame() -> void:
	#ResourceSaver.save(self, SAVE_GAME_PATH) #(SAVE_GAME_PATH, self)
#
#static func save_exists() -> bool:
	#return ResourceLoader.exists(SAVE_GAME_PATH)
#
#static func load_savegame() -> Resource:
	#if ResourceLoader.exists(SAVE_GAME_PATH):
		#return load(SAVE_GAME_PATH)
	#return null
