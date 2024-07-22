extends Control


func _ready():
	Global._ram_menu = self
	#Global.delivered_ram_items = ["chrome_exe", "vlc_exe", "edge_exe"]
	
	print("LOADED_ram_menu´´´ready´´´´´")



var selected_file
var file_content

func select_file(the_file):
	print(the_file)
	selected_file = the_file
	#var the_file2 = the_file.replace(".", "_")
	$Select_Panel/selected_label.text = the_file
	
	if FileAccess.file_exists("res://world/" + the_file + ".png"):
		$File_icon.texture = load("res://world/" + the_file + ".png")
	else:
		if ".exe" in the_file:
			$File_icon.texture = load("res://world/exe.png")
	#print("res://menu/" + the_file + ".txt")
	if FileAccess.file_exists("res://menu/" + the_file + ".txt"):
		file_content = FileAccess.open("res://menu/" + the_file + ".txt", FileAccess.READ)
		$file_content.text = file_content.get_as_text()
		$dotdotdot.show()
	else:
		$file_content.text = ""
		$dotdotdot.hide()
	
	# "võta info" nupp enabled/disabled
	if ".exe" in the_file or ".png" in the_file or ".mp4" in the_file or ".mp3" in the_file or ".txt" in the_file:
		$Info_Panel/take_info_btn.disabled = false
	else:
		$Info_Panel/take_info_btn.disabled = true



func _on_take_info_btn_pressed():
	if selected_file != "____________":
		$Info_Panel/take_info_btn.modulate = "00ff47" # green
		Global._player.opening_box = true
		Global._player.hold_item(selected_file + " info")
		print("võta ", selected_file, " info.")


func reload_files():
	select_file("____________")
	$Info_Panel/take_info_btn.modulate = "ffffff"
	# eemalda vanad failid
	for el in $Fail_Panel/ScrollContainer/VBoxContainer.get_children():
		if el.name != "palceholder" and el.name != "empty_label":
			$Fail_Panel/ScrollContainer/VBoxContainer.remove_child(el)
			el.queue_free()
	
	# lisa kõik kapis olevad failid
	for el in Global.items_in_lockers:
		print(el.item_name)
		if ".exe" in el.item_name or ".png" in el.item_name or ".mp4" in el.item_name or ".mp3" in el.item_name or ".txt" in el.item_name:
			var file_block = preload("res://file_block.tscn").instantiate()
			$Fail_Panel/ScrollContainer/VBoxContainer.add_child(file_block)
			file_block.ram_file = Global.items_in_lockers[el]
			file_block.text = Global.items_in_lockers[el]
		
	
	if Global.items_in_lockers == {}:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.show()
	else:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.hide()


func _on_back_button_pressed():
	Global._controlpanel.close_panel = true
