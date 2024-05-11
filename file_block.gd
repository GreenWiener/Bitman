extends RichTextLabel

#var task_type = ""

var ram_file

func _process(delta):
	pass


func _on_button_task_pressed():
	Global._ram_menu.select_file(ram_file)
	


#func set_ram_menu_text(set_text, the_file):
	#self.text = set_text
	#ram_file = the_file
	

