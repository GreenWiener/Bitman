extends Control


func _ready():
	$ScrollRows/Rows/task_binary_row.hide_arrow() # jooksuta task_binary_row.gd skriptis funktsioon hide_arrow()
	$ScrollRows/Rows/add_row_btn/add_row_button/remove_row_button.hide() # peida nupp
	#Global.task_binary_rows = []


func _on_add_row_btn_pressed():
	$ScrollRows/Rows/add_row_btn/add_row_button/remove_row_button.show()
	var new_row = preload("res://menu/task_binary_row.tscn")
	$ScrollRows/Rows.add_child(new_row.instantiate())
	$ScrollRows/Rows.move_child($ScrollRows/Rows/add_row_btn, $ScrollRows/Rows.get_child_count()) # liiguta nupp rivi lõppu
	print(Global.task_binary_rows)

func _on_remove_row_button_pressed():
	var last_row = $ScrollRows/Rows.get_child($ScrollRows/Rows.get_child_count()-2)
	last_row.remove_row_from_list()
	$ScrollRows/Rows.remove_child(last_row)
	if len(Global.task_binary_rows) <= 1: # kui on ainult 1 rida alles, peida remove nupp
		$ScrollRows/Rows/add_row_btn/add_row_button/remove_row_button.hide()



func check_answer():
	var player_answer
	var row_answers = []
	var correct_answer
	
	# mängija arvutatud kahendarvu saamine #
	for i in Global.task_binary_rows: 
		row_answers.append(i.get_row_answer())
	row_answers.reverse()
	player_answer = "".join(row_answers) # join liidab listi elemendid üheks stringiks
	
	if Global.task_dec_num != null:
		# õige vastuse arvutamine #
		var jaagitav = int(Global.task_dec_num)
		
		#print("jAAgutav : ",jaagitav)
		
		correct_answer = []
		while jaagitav > 0:
			correct_answer.append(jaagitav % 2) # jäägi ehk ühe kahendarvu numbri arvutamine
			jaagitav = jaagitav / 2
		correct_answer.reverse()
		correct_answer = "".join(correct_answer)
	
	# osaline lahenduse kontroll #
	var row_1st_nums = []
	var jagatav = int(Global.task_binary_num)
	while jagatav > 0:
		row_1st_nums.append(jagatav)
		jagatav = jagatav / 2
	#print("ROW_1ST_NUMS: ", row_1st_nums)
	
	var row_1st_num_check = 0
	for i in range(len(row_1st_nums)):
		for el in Global.task_binary_rows:
			if el.get_row_1st_num() == row_1st_nums[i-1]:
				#print(el.get_row_1st_num(), " = ", row_1st_nums[i-1])
				row_1st_num_check += 1
	
	print("player_answer: ", player_answer)
	print("correct_answer: ", correct_answer)
	print("row_1st_nums: ", row_1st_nums)
	
	##
	if player_answer != null and correct_answer != null and entered_answer != null:
		if int(player_answer) == int(correct_answer) and int(correct_answer) == int(entered_answer) and row_1st_num_check == len(row_1st_nums):
			print("TULEMUS: ÕIGE!")
			$kontroll.modulate = "00ff00"
			Global.task_cpu_finished = true
			Global._player.release_item(null, null)
		
		elif int(player_answer) != int(correct_answer):
			print("TULEMUS: lahenduse vastus on vale")
			$kontroll.modulate = "ff0000"
			
		elif int(correct_answer) != int(entered_answer):
			print("TULEMUS: sisestatud vastus on vale")
			$kontroll.modulate = "ff0000"
			
		elif row_1st_num_check != len(row_1st_nums):
			print("TULEMUS: lahendus on vale")
			$kontroll.modulate = "ff0000"
			
		else:
			print("TULEMUS: VALE")
			$kontroll.modulate = "ff0000"
	
	else:
		print("TULEMUS: VALE")
		$kontroll.modulate = "ff0000"
	
	
	
	

func _on_kontroll_pressed():
	check_answer()


var entered_answer
func _on_vastus_text_changed(new_text):
	print(new_text)
	entered_answer = new_text


func _on_example_btn_pressed():
	$Example.show()
	
func _on_close_example_btn_pressed():
	$Example.hide()
	

func _on_vastus_focus_entered():
	if DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_vastus_focus_exited():
	DisplayServer.virtual_keyboard_hide()


#&& Input.is_action_just_released("Interact_e")
func _on_back_button_pressed():
	Global._controlpanel.close_panel = true
