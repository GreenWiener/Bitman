extends Control


func boot_up():
	$AnimationPlayer.play("loading")
	AudioPlayer.play_fx("res://audio/computer_open.wav")
	
	if Global.language == "english" or Global.language == "skibidi":
		$loading_screen/Label.text = "Loading"
	else:
		$loading_screen/Label.text = "Laadimine"
	
	$files_menu/Scan_Panel/take_info_btn.modulate = "ffffff"
	
	$task_binary.hide()
	$files_menu.show()
	
	#for node in $files_menu/file_attributes/ScrollContainer/attributes/value.get_children(): ???????????????????????
	#	node.focus_mode = "None"
	
	# "skänni kood" nupp enabled/disabled
	if Global.holding_item_name != null and "kood - " in Global.holding_item_name:
		$files_menu/Scan_Panel/take_info_btn.disabled = false
	else:
		$files_menu/Scan_Panel/take_info_btn.disabled = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "loading" or anim_name == "RESET":
		AudioPlayer.play_fx("res://audio/computer_success.wav")




func _ready():
	Global._cpu_menu = self
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_english()
	
	


var selected_file
var file_content
var selected_music

func select_info(the_file):
	print(the_file)
	selected_file = the_file
	#var the_file2 = the_file.replace(".", "_")
	#$files_menu/Scan_Panel/take_info_btn.modulate = "ffffff"
	$files_menu/Select_Panel/selected_label.text = the_file
	$files_menu/content/audioplay_controls.visible = false
	$files_menu/content/file_content.visible = true
	$files_menu/file_attributes.visible = true
	$files_menu/file_attributes/ScrollContainer/attributes/name/author.visible = false
	$files_menu/file_attributes/ScrollContainer/attributes/value/author.visible = false
	$files_menu/content/audioplay_controls/play_btn.button_pressed = false
	$AudioStreamPlayer2D.stop()
	
	if FileAccess.file_exists("res://world/" + the_file + ".png"):
		$files_menu/File_icon.texture = load("res://world/" + the_file + ".png")
	else:
		if ".exe" in the_file:
			$files_menu/File_icon.texture = load("res://world/exe.png")
		elif ".mp4" in the_file:
			$files_menu/File_icon.texture = load("res://world/mp4.png")
		elif ".mp3" in the_file:
			$files_menu/File_icon.texture = load("res://world/mp3.png")
			if FileAccess.file_exists("res://audio/" + the_file + ".wav"):
				selected_music = load("res://audio/" + the_file + ".wav")
				$AudioStreamPlayer2D.stream = selected_music
				$files_menu/content/audioplay_controls.visible = true
				$files_menu/content/file_content.visible = false
				$files_menu/file_attributes/ScrollContainer/attributes/name/author.visible = true
				$files_menu/file_attributes/ScrollContainer/attributes/value/author.visible = true
				$files_menu/content/audioplay_controls/play_btn.icon = load("res://menu/play_btn.png")
				$AudioStreamPlayer2D.play(0)
				$files_menu/content/audioplay_controls/MusicTimeSlider.value = 0
				$AudioStreamPlayer2D.stop()
				
			
		elif ".txt" in the_file:
			$files_menu/File_icon.texture = load("res://world/txt.png")
		
		elif ".png" in the_file:
			$files_menu/File_icon.texture = load("res://world/png.png")
		
	#print("res://menu/" + the_file + ".txt")
	if FileAccess.file_exists("res://menu/" + the_file + ".txt"):
		file_content = FileAccess.open("res://menu/" + the_file + ".txt", FileAccess.READ)
		$files_menu/content/file_content.text = file_content.get_as_text()
		$files_menu/content/file_content/dotdotdot.show()
	elif FileAccess.file_exists("res://menu/" + the_file):
		file_content = FileAccess.open("res://menu/" + the_file, FileAccess.READ)
		$files_menu/content/file_content.text = file_content.get_as_text()
		$files_menu/content/file_content/dotdotdot.show()
	else:
		$files_menu/content/file_content.text = ""
		$files_menu/content/file_content/dotdotdot.hide()
	
	var attributes_file = FileAccess.open("res://world/file_attributes.txt", FileAccess.READ)
	var file_attributes = {}
	var line_of_attributes = []
	while attributes_file.get_position() < attributes_file.get_length():
		var files_line = attributes_file.get_line()
		if files_line != "" and "#" not in files_line and the_file in files_line:
			line_of_attributes = files_line.split(" | ")
			#file_attributes.append(files_line)
	
	if Array(line_of_attributes) != []:
		$files_menu/file_attributes/ScrollContainer/attributes/value/name.text = line_of_attributes[1]
		if ".mp3" in the_file:
			$files_menu/file_attributes/ScrollContainer/attributes/value/author.text = line_of_attributes[6]
		$files_menu/file_attributes/ScrollContainer/attributes/value/filetype.text = line_of_attributes[2]
		$files_menu/file_attributes/ScrollContainer/attributes/value/location.text = line_of_attributes[3]
		$files_menu/file_attributes/ScrollContainer/attributes/value/size.text = line_of_attributes[4]
		$files_menu/file_attributes/ScrollContainer/attributes/value/created.text = line_of_attributes[5]
		var temp_local_time = Time.get_date_string_from_system().split("-")
		var local_time = str(temp_local_time[2] + "." + temp_local_time[1] + "." + temp_local_time[0])
		$files_menu/file_attributes/ScrollContainer/attributes/value/accessed.text = str(local_time)

var global_music_volume = 0.0

func reload_info():
	$AudioStreamPlayer2D.stop()
	select_info("____________")
	$files_menu/File_icon.texture = load("res://world/file_icon.png")
	global_music_volume = Global.music_volume
	$files_menu/Scan_Panel/take_info_btn.modulate = "ffffff"
	# eemalda vanad failid
	for el in $files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer.get_children():
		if el.name != "palceholder" and el.name != "empty_label":
			$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer.remove_child(el)
			el.queue_free()
	
	#####Global.delivered_cpu_items.append("110-101.mp3 info") ##### test
	# lisa kõik kapis olevad failid
	for el in Global.delivered_cpu_items:
		#print(el.item_name)
		#if (".exe" in el.item_name or ".png" in el.item_name or ".mp4" in el.item_name or ".mp3" in el.item_name or ".txt" in el.item_name) and el.item_name != "egg.exe":
		var file_block = preload("res://file_block.tscn").instantiate()
		$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer.add_child(file_block)
		
		if " info" in el:
			file_block.ram_file = el.replace(" info", "")
			file_block.text = el.replace(" info", "")
		else:
			file_block.ram_file = el
			file_block.text = el
	
	if Global.delivered_cpu_items == []:
		$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer/empty_label.show()
	else:
		$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer/empty_label.hide()

	$files_menu/file_attributes.visible = false
	$files_menu/file_attributes/ScrollContainer/attributes/value/name.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/author.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/filetype.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/location.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/size.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/created.text = " "
	$files_menu/file_attributes/ScrollContainer/attributes/value/accessed.text = " "


func _on_back_button_pressed():
	Global._controlpanel.close_panel = true
	close_menu()

func close_menu():
	AudioPlayer.play_fx("res://audio/menu_close.wav")
	$BackButton/HelpArrow.visible = false
	AudioPlayer.set_music_volume(global_music_volume)
	play_btn_icon = true


func _on_take_info_btn_pressed():
	if Global.language == "english" or Global.language == "skibidi":
		$loading_screen/Label.text = "Scanning the code"
	else:
		$loading_screen/Label.text = "koodi skännimine"
	
	$AnimationPlayer.play("loading")
	if "kood - " in Global.holding_item_name and Global.holding_item_name != null:
		$task_binary.show()
		$files_menu.hide()
	else:
		$task_binary.hide()
		$files_menu.show()
		$scan_error.show()
		$files_menu/Scan_Panel/take_info_btn.modulate = "ff0047" # red

func successful_scan():
	$files_menu/Scan_Panel/take_info_btn.modulate = "00ff47" # green
	$files_menu/Scan_Panel/take_info_btn.disabled = true
	Global.delivered_cpu_items.append(Global.deliver_cpu_item)
	reload_info()
	select_info(Global.deliver_cpu_item.replace(" info", ""))



func _on_ok_btn_pressed():
	$scan_error.hide()


# music stuff
var play_btn_icon = true

func _process(delta):
	if Input.is_action_just_released("Close"):
		close_menu()
	
	if Input.is_action_just_released("space") and $loading_screen.visible == true:
		$AnimationPlayer.play("RESET")
	
	if $AudioStreamPlayer2D.playing == false:
		if play_btn_icon == false:
			play_btn_icon = true
			$files_menu/content/audioplay_controls/play_btn.icon = load("res://menu/play_btn.png") # idk 
			##AudioPlayer.set_music_volume(global_music_volume)
	else:
		$files_menu/content/audioplay_controls/TimeLabel.text = str($AudioStreamPlayer2D.get_playback_position())
		if dragging_time == false:
			$files_menu/content/audioplay_controls/MusicTimeSlider.value = $AudioStreamPlayer2D.get_playback_position()
		
	$AudioStreamPlayer2D.volume_db = $files_menu/content/audioplay_controls/MusicVolumeSlider.value
	
	$files_menu/content/audioplay_controls/VolumeLabel.text = str(int(($files_menu/content/audioplay_controls/MusicVolumeSlider.value + 30) * 2.5))
	
	if $files_menu/content/audioplay_controls/MusicTimeSlider.value == $files_menu/content/audioplay_controls/MusicTimeSlider.max_value:
		$files_menu/content/audioplay_controls/MusicTimeSlider.value = 0


func _on_play_btn_pressed():
	if $AudioStreamPlayer2D.playing == false:
		$files_menu/content/audioplay_controls/MusicTimeSlider.max_value = $AudioStreamPlayer2D.stream.get_length()
		$files_menu/content/audioplay_controls/play_btn.icon = load("res://menu/stop_btn.png")
		#$AudioStreamPlayer2D.volume_db = Global.music_volume
		$AudioStreamPlayer2D.play($files_menu/content/audioplay_controls/MusicTimeSlider.value)
		global_music_volume = Global.music_volume
		AudioPlayer.set_music_volume(-100)
		play_btn_icon = false
	else:
		$files_menu/content/audioplay_controls/play_btn.icon = load("res://menu/play_btn.png")
		$AudioStreamPlayer2D.stop()
		AudioPlayer.set_music_volume(global_music_volume)



var stop_autoplayafterdrag = false
func _on_music_time_slider_drag_ended(value_changed):
	if $AudioStreamPlayer2D.playing == false:
		stop_autoplayafterdrag = true
	$AudioStreamPlayer2D.play($files_menu/content/audioplay_controls/MusicTimeSlider.value)
	#$files_menu/content/audioplay_controls/MusicTimeSlider.value = value_changed
	if stop_autoplayafterdrag == true:
		stop_autoplayafterdrag = false
		$AudioStreamPlayer2D.stop()
	dragging_time = false
	$files_menu/content/audioplay_controls/TimeLabel.text = str($AudioStreamPlayer2D.get_playback_position())

var dragging_time = false
func _on_music_time_slider_drag_started():
	dragging_time = true
	
	


func _on_music_volume_slider_drag_started():
	$files_menu/content/audioplay_controls/VolumeLabel.visible = true
	$files_menu/content/audioplay_controls/volume_icon.visible = false

func _on_music_volume_slider_drag_ended(value_changed):
	$files_menu/content/audioplay_controls/volume_icon.visible = true
	$files_menu/content/audioplay_controls/VolumeLabel.visible = false




func lang_english():
	$files_menu/Label2.text = "CPU infopanel"
	$loading_screen/Label.text = "Loading"
	$files_menu/Scan_Panel/take_info_btn.text = "Scan a new code"
	$files_menu/Scan_Panel/Label.text = "Scan the decimal code you got from scanning the file info, in order to see the info on the CPU infopanel."
	$files_menu/FailInfo_Panel/failid_label2.text = "All info, that's been scanned into the CPU"
	$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer/empty_label.text = "Nothing here at the moment."
	
func lang_skibidi():
	$files_menu/Label2.text = "CPU skibidi center"
	$loading_screen/Label.text = "Loading"
	$files_menu/Scan_Panel/take_info_btn.text = "Scan a new code"
	$files_menu/Scan_Panel/Label.text = "Scan the decimal code you got from scanning the file info, in order to see the info on the CPU infopanel."
	$files_menu/FailInfo_Panel/failid_label2.text = "All info, that's been scanned into the CPU"
	$files_menu/FailInfo_Panel/ScrollContainer/VBoxContainer/empty_label.text = "Nothing here at the moment."

