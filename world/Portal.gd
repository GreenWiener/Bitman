extends Area2D

@export_file var next_scene_path = ""
@export var player_spawn_location = Vector2.ZERO


func _on_body_entered(body):
	if next_scene_path != "":
		#if body.name == "player": # ↓ sama asi teist moodi kirjas
		if body is Player and Global._player.entered_portal == false: # kui portaali alasse siseneb mängija
			Global._player.entered_portal = true
			Global._world.save_all_items() # kõikide esemete salvestamine eelmises stseenis
			Global.player_inital_map_position = player_spawn_location # mängija asukoha määramine
			StageManager.changeScene(next_scene_path) # stseen vahetatakse uueks
			#for el in Global.item_bodies_list:
			#	el.update_item_visibility()
			Global.item_bodies_list = []
	else:
		print("'next_scene_path' pole määratud!")
	

