extends Button


func _on_pressed():
	StageManager.changeScene("res://start_menu.tscn")
	SaveGame.save_settings()


func _on_demo_button_pressed():
	var demo_vid = load("res://menu/demo_video.tscn").instantiate()
	$"../..".add_child(demo_vid)
