extends Button

func _on_pressed():
	#get_tree().change_scene_to_file("res://world/world.tscn")
	if Global.most_recent_scene != null:
		StageManager.changeScene(Global.most_recent_scene)
	else:
		StageManager.changeScene("res://world/world.tscn")
