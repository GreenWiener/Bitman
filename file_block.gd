extends RichTextLabel

#var task_type = ""

var ram_file



func _on_button_task_pressed():
	AudioPlayer.play_fx("res://audio/tick2.wav")
	if Global.world_name == "RAM":
		Global._ram_menu.select_file(ram_file)
	elif Global.world_name == "CPU":
		Global._cpu_menu.select_info(ram_file)
	


#func set_ram_menu_text(set_text, the_file):
	#self.text = set_text
	#ram_file = the_file
	

