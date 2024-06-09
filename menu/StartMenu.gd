extends Control


func _on_play_button_pressed():
	#get_tree().change_scene_to_file("res://world/world.tscn")
	if Global.most_recent_scene != null:
		StageManager.changeScene(Global.most_recent_scene)
	else:
		StageManager.changeScene("res://world/world.tscn")



func _on_info_button_pressed():
	StageManager.changeScene("res://menu/info_menu.tscn")


func _on_demo_button_pressed():
	StageManager.changeScene("res://menu/demo_vid_menu.tscn")

