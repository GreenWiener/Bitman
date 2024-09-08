extends Control


var unicode_syms = {'!': 33, '"': 34, '#': 35, '$': 36, '%': 37, '&': 38, "'": 39, '(': 40, ')': 41, '*': 42, '+': 43, ',': 44, '-': 45, '.': 46, '/': 47, '0': 48, '1': 49, '2': 50, '3': 51, '4': 52, '5': 53, '6': 54, '7': 55, '8': 56, '9': 57, ':': 58, ';': 59, '<': 60, '=': 61, '>': 62, '?': 63, '@': 64, 'A': 65, 'B': 66, 'C': 67, 'D': 68, 'E': 69, 'F': 70, 'G': 71, 'H': 72, 'I': 73, 'J': 74, 'K': 75, 'L': 76, 'M': 77, 'N': 78, 'O': 79, 'P': 80, 'Q': 81, 'R': 82, 'S': 83, 'T': 84, 'U': 85, 'V': 86, 'W': 87, 'X': 88, 'Y': 89, 'Z': 90, '[': 91, '\\': 92, ']': 93, '^': 94, '_': 95, '`': 96, 'a': 97, 'b': 98, 'c': 99, 'd': 100, 'e': 101, 'f': 102, 'g': 103, 'h': 104, 'i': 105, 'j': 106, 'k': 107, 'l': 108, 'm': 109, 'n': 110, 'o': 111, 'p': 112, 'q': 113, 'r': 114, 's': 115, 't': 116, 'u': 117, 'v': 118, 'w': 119, 'x': 120, 'y': 121, 'z': 122, '{': 123, '|': 124, '}': 125, '~': 126, 'Õ': 213, 'Ä': 196, 'Ö': 214, 'Ü': 220, 'õ': 245, 'ä': 228, 'ö': 246, 'ü': 252, 'Š': 352, 'š': 353, 'Ž': 381, 'ž': 382}


func boot_up():
	$AnimationPlayer.play("loading")
	AudioPlayer.play_fx("res://audio/computer_open.wav")
	$content/unicode_tabel.visible = false

	$Select_Panel/Panel/Control/selected_label.modulate = "ff0000"
	if Global.language == "english" or Global.language == "skibidi":
		$Select_Panel/Panel/Control/selected_label.text = "No file selected!"
	else:
		$Select_Panel/Panel/Control/selected_label.text = "Fail on valimata!"
	
	$Info_Panel/take_info_btn.disabled = true
	$Select_Panel/LineEdit.editable = false
	
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "loading" or anim_name == "RESET":
		AudioPlayer.play_fx("res://audio/computer_success.wav")



func _ready():
	Global._ram_menu = self
	#Global.delivered_ram_items = ["chrome_exe", "vlc_exe", "edge_exe"]
	
	print("LOADED_ram_menu´´´ready´´´´´")
	
	$BackButton/HelpArrow.visible = false
	$content/audioplay_controls.visible = false
	
	$content/audioplay_controls/MusicVolumeSlider.value = Global.music_volume
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_english()


var selected_file
var file_content
var selected_music

func select_file(the_file):
	print("select_file: ", the_file)
	selected_file = the_file
	#var the_file2 = the_file.replace(".", "_")
	#$Info_Panel/take_info_btn.modulate = "ffffff"
	$Select_Panel/Panel/Control/selected_label.text = the_file.replace(".file", "")
	$content/audioplay_controls.visible = false
	#$content/file_content.visible = true
	$content/audioplay_controls/play_btn.button_pressed = false
	$AudioStreamPlayer2D.stop()
	
	if "Fail on valimata!" not in the_file or "No file selected!" not in the_file:
		$content/unicode_tabel.visible = true
		$Select_Panel/Panel/Control/selected_label.modulate = "ffffff"
		
	
	
		
	##print("res://menu/" + the_file + ".txt")
	#if FileAccess.file_exists("res://menu/" + the_file + ".txt"):
		#file_content = FileAccess.open("res://menu/" + the_file + ".txt", FileAccess.READ)
		#$content/file_content.text = file_content.get_as_text()
		##$dotdotdot.show()
	#elif FileAccess.file_exists("res://menu/" + the_file):
		#file_content = FileAccess.open("res://menu/" + the_file, FileAccess.READ)
		#$content/file_content.text = file_content.get_as_text()
		##$dotdotdot.show()
	#else:
		#$content/file_content.text = ""
		##$dotdotdot.hide()
	#
	# "võta info" nupp enabled/disabled
	#if ".exe" in the_file or ".png" in the_file or ".mp4" in the_file or ".mp3" in the_file or ".txt" in the_file:
	if ".file" in the_file:
		if Global.item_name != null and "info" not in Global.item_name or Global.item_name == null:
			$Info_Panel/take_info_btn.disabled = false
		$Select_Panel/LineEdit.editable = true
	else:
		$Info_Panel/take_info_btn.disabled = true
		$Select_Panel/LineEdit.editable = false



func _on_take_info_btn_pressed():
	if selected_file != "Fail on valimata!" and selected_file != "No file selected!":
		if $Info_Panel/take_info_btn.modulate == Color("00ff47"):
			$Info_Panel/take_info_btn.disabled = true
		#if Global.holding_item_name != null:
		if Global.item_name != null and "info" not in Global.item_name or Global.item_name == null:
			var filename_in_letters = []
			#for char in selected_file:
			#	filename_in_letters.append(unicode_syms[char])
			
			var submitted_text = $Select_Panel/LineEdit.text.split()
			print("submitted_text: ", submitted_text)
			for sym in submitted_text:
				if sym in unicode_syms:
					filename_in_letters.append(str(unicode_syms[sym]) + " ")
					print("filename_in_letters: ", filename_in_letters)
				else:
					filename_in_letters = [""]#[]
			filename_in_letters = "".join(filename_in_letters)
			filename_in_letters = filename_in_letters.erase(len(filename_in_letters)-1)
			print(filename_in_letters, " ==-==-== ", selected_file.replace(".file", ""))
			
			if filename_in_letters == selected_file.replace(".file", ""):
				$Info_Panel/take_info_btn.modulate = "00ff47" # green'
				AudioPlayer.play_fx("res://audio/beep1.wav")
				Global._player.opening_box = true
				Global._player.release_item(Global.item_name, Global.box_item)
				Global._player.hold_item($Select_Panel/LineEdit.text + " info")
				print("võta ", selected_file, " info.")
				
				# subtask thing
				print(selected_file, " -selected_file")
				print(Global.deliver_ram_item, " -Global.deliver_ram_item")
				print(Global.subtask, " -Global.subtask")
				if Global.deliver_ram_item == selected_file and Global.subtask == 3:
					Global._task_bar.next_subtask()
				Global.deliver_ram_item = $Select_Panel/LineEdit.text + " info"
				
				if FileAccess.file_exists("res://world/" + $Select_Panel/LineEdit.text + ".png"):
					$File_icon.texture = load("res://world/" + $Select_Panel/LineEdit.text + ".png")
				else:
					if ".exe" in $Select_Panel/LineEdit.text:
						$File_icon.texture = load("res://world/exe.png")
					elif ".mp4" in $Select_Panel/LineEdit.text:
						$File_icon.texture = load("res://world/mp4.png")
					elif ".mp3" in $Select_Panel/LineEdit.text:
						$File_icon.texture = load("res://world/mp3.png")
						
					elif ".txt" in $Select_Panel/LineEdit.text:
						$File_icon.texture = load("res://world/txt.png")
					
					elif ".png" in $Select_Panel/LineEdit.text:
						$File_icon.texture = load("res://world/png.png")
				
			#else:
				#$Info_Panel/take_info_btn.modulate = "00ff47" # green
				#Global._player.opening_box = true
				#Global._player.hold_item(selected_file + " info")
				#print("võta ", selected_file, " info.")
				if "ram_menu_close" not in Global.showed_helparrow:
					$BackButton/HelpArrow.visible = true
					Global.showed_helparrow.append("ram_menu_close")
			else:
				$Info_Panel/take_info_btn.modulate = "ff0047" # red
				AudioPlayer.play_fx("res://audio/beep_bad.wav")

func reload_files():
	$content/unicode_tabel.visible = false
	$AudioStreamPlayer2D.stop()
	#select_file("Fail on valimata!")
	
	$Select_Panel/LineEdit.text = ""
	$File_icon.texture = load("res://world/file_icon.png")
	global_music_volume = Global.music_volume
	$Info_Panel/take_info_btn.modulate = "ffffff"
	# eemalda vanad failid
	for el in $Fail_Panel/ScrollContainer/VBoxContainer.get_children():
		if el.name != "palceholder" and el.name != "empty_label":
			$Fail_Panel/ScrollContainer/VBoxContainer.remove_child(el)
			el.queue_free()
	
	# lisa kõik kapis olevad failid
	for el in Global.items_in_lockers:
		print(el.item_name)
		#if (".exe" in el.item_name or ".png" in el.item_name or ".mp4" in el.item_name or ".mp3" in el.item_name or ".txt" in el.item_name) and el.item_name != "egg.exe":
		if ".file" in el.item_name:
			var file_block = preload("res://file_block.tscn").instantiate()
			$Fail_Panel/ScrollContainer/VBoxContainer.add_child(file_block)
			file_block.ram_file = Global.items_in_lockers[el]
			file_block.text = Global.items_in_lockers[el].replace(".file", "")
		
	
	if Global.items_in_lockers == {}:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.show()
	else:
		$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.hide()
	
	##var binary_nums_list = random_200binary_nums().split()
	##print("binary_nums_list: ", binary_nums_list)
	##for i in range(1, $content/unicode_tabel/GridContainer.get_child_count()):
	##	$content/unicode_tabel/GridContainer.get_child(i-1).digit = binary_nums_list[i-1]

#func random_200binary_nums():
	#var number_found = false
	#var randbin_nums
	#while number_found == false:
		#randbin_nums = []
		#for i in range(1, 201):
			#var temp = str(randi_range(0, 1))
	 		#
			#randbin_nums.append(temp)
		#var randbin_num = "".join(randbin_nums)
		#if randbin_num not in Global.all_randbin_nums:
			#Global.all_randbin_nums.append(randbin_num)
			#number_found = true
	#return "".join(randbin_nums)




func _on_back_button_pressed():
	close_menu()
	Global._controlpanel.close_panel = true
	
func close_menu():
	AudioPlayer.play_fx("res://audio/menu_close.wav")
	$BackButton/HelpArrow.visible = false
	AudioPlayer.set_music_volume(global_music_volume)
	play_btn_icon = true
	
var play_btn_icon = true
func _process(_delta):
	if Input.is_action_just_released("Close"):
		close_menu()
	
	if Input.is_action_just_released("space") and $loading_screen.visible == true:
		$AnimationPlayer.play("RESET")
	#if $AudioStreamPlayer2D.playing == true:
		#print("s")
		#if $content/audioplay_controls/play_btn.icon != play_btn_icon:
			#play_btn_icon = load("res://menu/stop_btn.png")
			#$content/audioplay_controls/play_btn.icon = play_btn_icon
	#else:
		#if $content/audioplay_controls/play_btn.icon != play_btn_icon:
			#play_btn_icon = load("res://menu/play_btn.png")
			#$content/audioplay_controls/play_btn.icon = play_btn_icon
	if $AudioStreamPlayer2D.playing == false:
		if play_btn_icon == false:
			play_btn_icon = true
			$content/audioplay_controls/play_btn.icon = load("res://menu/play_btn.png") # idk 
			##AudioPlayer.set_music_volume(global_music_volume)
	else:
		$content/audioplay_controls/TimeLabel.text = str($AudioStreamPlayer2D.get_playback_position())
		if dragging_time == false:
			$content/audioplay_controls/MusicTimeSlider.value = $AudioStreamPlayer2D.get_playback_position()
		
	$AudioStreamPlayer2D.volume_db = $content/audioplay_controls/MusicVolumeSlider.value
	
	$content/audioplay_controls/VolumeLabel.text = str(int(($content/audioplay_controls/MusicVolumeSlider.value + 30) * 2.5))
	
	if $content/audioplay_controls/MusicTimeSlider.value == $content/audioplay_controls/MusicTimeSlider.max_value:
		$content/audioplay_controls/MusicTimeSlider.value = 0
	


var global_music_volume = 0.0

func _on_play_btn_pressed():
	if $AudioStreamPlayer2D.playing == false:
		$content/audioplay_controls/MusicTimeSlider.max_value = $AudioStreamPlayer2D.stream.get_length()
		$content/audioplay_controls/play_btn.icon = load("res://menu/stop_btn.png")
		#$AudioStreamPlayer2D.volume_db = Global.music_volume
		$AudioStreamPlayer2D.play($content/audioplay_controls/MusicTimeSlider.value)
		global_music_volume = Global.music_volume
		AudioPlayer.set_music_volume(-100)
		play_btn_icon = false
	else:
		$content/audioplay_controls/play_btn.icon = load("res://menu/play_btn.png")
		$AudioStreamPlayer2D.stop()
		AudioPlayer.set_music_volume(global_music_volume)



var stop_autoplayafterdrag = false
func _on_music_time_slider_drag_ended(value_changed):
	if $AudioStreamPlayer2D.playing == false:
		stop_autoplayafterdrag = true
	$AudioStreamPlayer2D.play($content/audioplay_controls/MusicTimeSlider.value)
	#$content/audioplay_controls/MusicTimeSlider.value = value_changed
	if stop_autoplayafterdrag == true:
		stop_autoplayafterdrag = false
		$AudioStreamPlayer2D.stop()
	dragging_time = false
	$content/audioplay_controls/TimeLabel.text = str($AudioStreamPlayer2D.get_playback_position())

var dragging_time = false
func _on_music_time_slider_drag_started():
	dragging_time = true
	
	


func _on_music_volume_slider_drag_started():
	$content/audioplay_controls/VolumeLabel.visible = true
	$content/audioplay_controls/volume_icon.visible = false

func _on_music_volume_slider_drag_ended(value_changed):
	$content/audioplay_controls/volume_icon.visible = true
	$content/audioplay_controls/VolumeLabel.visible = false


func _on_delete_sym_btn_pressed():
	#var delete_sym = str($Select_Panel/LineEdit.text.split()[len($Select_Panel/LineEdit.text.split())-1])
	#print("delete_sym: ", delete_sym)
	$Select_Panel/LineEdit.release_focus()
	$Select_Panel/LineEdit.text = $Select_Panel/LineEdit.text.erase(len($Select_Panel/LineEdit.text)-1)
	AudioPlayer.play_fx("res://audio/tick2.wav")


func _on_delete_sym_btn_button_up():
	$Select_Panel/LineEdit/delete_sym_btn.modulate = "225dce" # default blue


func write_sym(the_symbol):
	$Select_Panel/LineEdit.release_focus()
	$Select_Panel/LineEdit.text = $Select_Panel/LineEdit.text + the_symbol



func _on_delete_sym_btn_button_down():
	$Select_Panel/LineEdit/delete_sym_btn.modulate = "2985da"
	print("button is DOWN")





func lang_english():
	$Label2.text = "RAM infopanel"
	$loading_screen/Label.text = "Loading files"
	$Fail_Panel/failid_label.text = "Files"
	$Fail_Panel/failid_label2.text = "All the files that are inside RAM"
	$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.text = "Nothing here at the moment."
	$Select_Panel/Label.text = "The file name is represented using Unicode codes (in decimal numbers) that correspond to characters. Enter the file name in characters following the Unicode code table."
	$content/unicode_tabel/Label.text = "Unicode codes tabel"
	$Info_Panel/take_info_btn.text = "Get file info"

func lang_skibidi():
	$Label2.text = "RAM skibidi center"
	$loading_screen/Label.text = "Loading files"
	$Fail_Panel/failid_label.text = "Files"
	$Fail_Panel/failid_label2.text = "All the files that are inside RAM"
	$Fail_Panel/ScrollContainer/VBoxContainer/empty_label.text = "Do something with your life."
	$Select_Panel/Label.text = "The file name is represented using Unicode codes (in decimal numbers) that correspond to characters. Enter the file name in characters following the Unicode code table."
	$content/unicode_tabel/Label.text = "Unicode codes tabel"
	$Info_Panel/take_info_btn.text = "Get file info"
