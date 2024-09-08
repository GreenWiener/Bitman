# ma tean, et see kirjutatakse "decimal" mitte demical, ma tegin kirjavea ja seda on liiga tüütu nüüd parandada

extends Control

#@onready var demical_row = preload("res://menu/task_demical_row.tscn").instantiate()


func boot_up():
	if "ssd_menu_help" not in Global.showed_helparrow:
		$example_btn/HelpArrow.show()
	
	$AnimationPlayer.play("loading")
	AudioPlayer.play_fx("res://audio/computer_open.wav")
	
	if "SSD-task" not in Global.task_ongoing:
		$notask_label.show()
	else:
		$notask_label.hide()
	
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_english()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "loading" or anim_name == "RESET":
		AudioPlayer.play_fx("res://audio/computer_success.wav")


func _ready():
	Global._task_decimal = self
	# esimese ploki lisamine
	var demical_row = preload("res://menu/task_demical_row.tscn").instantiate()
	$ScrollContainer/GridContainer/Add_row/remove_row_btn.hide()
	$ScrollContainer/GridContainer.add_child(demical_row)
	$ScrollContainer/GridContainer.move_child($ScrollContainer/GridContainer/Add_row, $ScrollContainer/GridContainer.get_child_count()) # liiguta nupp viimaseks
	demical_row.hide_pluss()
	$BackButton/HelpArrow.visible = false
	
	$Example/translation_label.visible = false



func _process(_delta):
	if Input.is_action_just_released("Close"):
		close_menu()
	
	if Input.is_action_just_released("space") and $loading_screen.visible == true:
		$AnimationPlayer.play("RESET")
	
	# binaararvu teksti panemine
	if Global.task_bin_num == null:
		$num_placeholder/binary_num.text = ""
	else:
		$num_placeholder/binary_num.text = str(Global.task_bin_num)
		binary_num = Global.task_bin_num
		binary_num_digits = binary_num.split()


func _on_add_row_btn_pressed():
	AudioPlayer.play_fx("res://audio/bop.wav")
	$ScrollContainer/GridContainer/Add_row/remove_row_btn.show()
	
	var demical_row = preload("res://menu/task_demical_row.tscn").instantiate()
	$ScrollContainer/GridContainer.add_child(demical_row)
	demical_row.get_node("binary_num_digit").grab_focus()
	$ScrollContainer/GridContainer.move_child($ScrollContainer/GridContainer/Add_row, $ScrollContainer/GridContainer.get_child_count()) # liiguta nupp viimaseks
	
func _on_remove_row_btn_pressed():
	AudioPlayer.play_fx("res://audio/bop2.wav")
	var last_row = $ScrollContainer/GridContainer.get_child($ScrollContainer/GridContainer.get_child_count()-2)
	#last_row.remove_row_from_list()
	$ScrollContainer/GridContainer.remove_child(last_row)
	if $ScrollContainer/GridContainer.get_child_count() <= 3: # kui on ainult 1 plokk alles, peida remove nupp
		$ScrollContainer/GridContainer/Add_row/remove_row_btn.hide()


var binary_num
var binary_num_digits

## sisestatud binaararv
#func _on_binary_num_text_changed(new_text):
	#binary_num = new_text
	#binary_num_digits = binary_num.split()
	




var correct_answer
var calculated_answer = 0

func _correct_answer():
	var aste = len(binary_num_digits)-1
	#print("binary_num_digits: ", binary_num_digits)
	for i in binary_num_digits:
		var calculation = int(i) * 2 ** aste
		calculated_answer += calculation
		#print("i: ", i, " aste: ", aste)
		aste -= 1
	
	#print("VASTUS: ", calculated_answer)
	
	$Control/demical_num.text = str(calculated_answer) # näita õiget arvutatud vastust


var correct
func _on_kontroll_pressed():
	print("kontroll...")



	print("child_count: ", $ScrollContainer/GridContainer.get_child_count())
	
	var indeks = 0
	var correct_digits_count = 0
	var correct_astmed_count = 0
	#for i in $ScrollContainer/GridContainer.get_child_count():
	if binary_num_digits != null:
		for el in $ScrollContainer/GridContainer.get_children():
			print("el: ", el)
			#var x = $ScrollContainer/GridContainer.get_child_count()-2
			if indeks < len(binary_num_digits):
				if el.name != "Add_row":
					print("digit: ", el.get_binary_digit(), " == ", binary_num_digits[indeks])
					if el.get_binary_digit() == binary_num_digits[indeks]:
						correct_digits_count += 1
					print("aste: ", el.get_binary_aste(), " == ", str(len(binary_num_digits)-1-indeks))
					if el.get_binary_aste() == str(len(binary_num_digits)-1-indeks):
						correct_astmed_count += 1
					indeks += 1
		
		# kui on õige
		print(correct_digits_count, " == ", len(binary_num_digits), " and ", correct_astmed_count, " == ", len(binary_num_digits), " and ", $ScrollContainer/GridContainer.get_child_count()-1, " == ", len(binary_num_digits))
		if correct_digits_count == len(binary_num_digits) and correct_astmed_count == len(binary_num_digits) and $ScrollContainer/GridContainer.get_child_count()-1 == len(binary_num_digits):
			print("ÕIGE VASTUS")
			$Control/kontroll.modulate = "00ff00" # green
			AudioPlayer.play_fx("res://audio/beep1.wav")
			$AnimationPlayer.play("correct")
			#if Global.helparrow_state == "ssd_menu" or Global.helparrow_state == "done_1st_task":
			if "ssd_menu_close" not in Global.showed_helparrow:
				$BackButton/HelpArrow.visible = true
				Global.showed_helparrow.append("ssd_menu_close")
			if "ssd_menu_help" not in Global.showed_helparrow:
				$example_btn/HelpArrow.visible = false
				Global.showed_helparrow.append("ssd_menu_help")
			_correct_answer() # arvuta kümnendarvuline vastus'
			Global.bin_task_completed_last = calculated_answer
			Global.bin_tasks_completed.append(calculated_answer)
			if Global.subtask == 1:
				Global._task_bar.next_subtask()
			
			#if Global.helparrow_state == "ssd_menu":
			#	Global.remove_HelpArrow(self)
			
			if Global.item_name != null and "kapi_kood" not in Global.item_name or Global.item_name == null:
				
				# kapi koodi itemi andmine kätte
				Global._player.release_item(Global.item_name, Global.box_item)
				Global._player.hold_item("kapi_kood1 " + str(calculated_answer))
			calculated_answer = 0
			
		else:
			print("VALE VASTUS")
			$Control/kontroll.modulate = "ff0000" # red
			AudioPlayer.play_fx("res://audio/beep_bad.wav")
			$AnimationPlayer.play("wrong")





func _on_example_btn_pressed():
	AudioPlayer.play_fx("res://audio/tick.wav")
	$Example.visible = !$Example.visible
	#hide_helparrow()
	
	$example_btn/HelpArrow.hide()
	if "ssd_menu_help" not in Global.showed_helparrow:
		Global.showed_helparrow.append("ssd_menu_help")
	#if Global.helparrow_state == "ssd_menu":
		#Global.remove_HelpArrow(self)

func _on_close_example_btn_pressed():
	AudioPlayer.play_fx("res://audio/tick2.wav")
	$Example.hide()


func _on_back_button_pressed():
	close_menu()
	Global._controlpanel.close_panel = true


func close_menu():
	AudioPlayer.play_fx("res://audio/menu_close.wav")
	$BackButton/HelpArrow.visible = false


func kill_scene():
	print("<task_demical> KILLED")
	self.queue_free()





func lang_english():
	$Task_explain/Label.text = "Convert the given binary number to decimal number by filling in the blank boxes in the solution with the correct numbers. The computer calculates the answer automatically. You can add boxes by pressing the "+" button."
	$Control/demical_num.placeholder_text = "answer"
	$Control/kontroll.text = "CHECK"
	$loading_screen/Label.text = "Loading"
	$Example/Sprite2D.texture = load("res://menu/task_decimal_example.png")
	$Example/translation_label.visible = true
	$correct_explain.text = "Correct solution! The machine gave you a code!"
	$wrong_explain.text = "Incorrect solution! Try again."
	

func lang_skibidi():
	$Task_explain/Label.text = "Convert the given binary number to decimal number by filling in the blank boxes in the solution with the correct numbers. The computer calculates the answer automatically. You can add boxes by pressing the "+" button. Also, don't forget to stay skibidi!"
	$Control/demical_num.placeholder_text = "answer"
	$Control/kontroll.text = "CHECK"
	$loading_screen/Label.text = "Loading"
	$Example/Sprite2D.texture = load("res://menu/task_decimal_example.png")
	$Example/translation_label.visible = true
	$correct_explain.text = "Correct solution! The machine gave you a code!"
	$wrong_explain.text = "Incorrect solution! Try again."
	
