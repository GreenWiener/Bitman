extends Button


func _on_pressed():
	AudioPlayer.play_fx("res://audio/btn_menu_back.wav")
	StageManager.changeScene("res://start_menu.tscn")
	SaveGame.save_settings()


func _on_demo_button_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	var demo_vid = load("res://menu/demo_video.tscn").instantiate()
	$"../..".add_child(demo_vid)
