extends Control


func _on_close_button_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	queue_free()


func _on_play_btn_pressed():
	pass
