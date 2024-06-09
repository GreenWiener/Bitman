extends Control


func _ready():
	Global._ram_menu = self
	#Global.delivered_ram_items = ["chrome_exe", "vlc_exe", "edge_exe"]
	
	print("LOADED_ram_menu´´´ready´´´´´")



var selected_file
var file_content

func select_file(the_file):
	selected_file = the_file
	$Select_Panel/selected_label.text = the_file
	$File_icon.texture = load("res://world/" + the_file + ".png")
	if ResourceLoader.exists("res://menu/" + the_file + ".txt"):
		file_content = FileAccess.open("res://menu/" + the_file + ".txt", FileAccess.READ)
		$file_content.text = file_content.get_as_text()
		$dotdotdot.show()
	else:
		$file_content.text = ""
		$dotdotdot.hide()
	
	# "võta info" nupp enabled/disabled
	if "_exe" in the_file or "_file" in the_file:
		$Info_Panel/take_info_btn.disabled = false
	else:
		$Info_Panel/take_info_btn.disabled = true



func _on_take_info_btn_pressed():
	if selected_file != "____________":
		Global._player.opening_box = true
		Global._player.hold_item(selected_file + " info")
		print("võta ", selected_file, " info.")


func reload_files():
	select_file("____________")
	# eemalda vanad failid
	for el in $Fail_Panel/ScrollContainer/VBoxContainer.get_children():
		if el.name != "palceholder" and el.name != "empty_label":
			$Fail_Panel/ScrollContainer/VBoxContainer.remove_child(el)
			el.queue_free()
	
	# lisa kõik kapis olevad failid
	for el in Global.items_in_lockers:
		print(el.item_name)
		if "_exe" in el.item_name or "_file" in el.item_name:
			var file_block = preload("res://file_block.tscn").instantiate()
			$Fail_Panel/ScrollContainer/VBoxContainer.add_child(file_block)
			file_block.ram_file = Global.items_in_lockers[el]
			file_block.text = Global.items_in_lockers[el]
		
	
	if Global.items_in_lockers == {}:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.show()
	else:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.hide()
