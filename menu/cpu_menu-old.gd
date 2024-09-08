extends Control
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#load_tasks()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
##func _on_line_edit_text_submitted(new_text):
	##if new_text == "vastus":
		##print("Õige!")
	##else:
		##print("Vale!")
#
#var psu_fix_cooldown = false
#
#var loendaja = 1
#
#func new_task():
	#var task_block = preload("res://task_block.tscn").instantiate()
	#var random_task = Global.tasks[randi() % Global.tasks.size()] # valib suvalise ülesande listist Global.tasks = ["SSD-task","RAM-task"]
	#$Task_Panel/ScrollContainer/VBoxContainer.add_child(task_block)
	#if random_task == "SSD-task" or random_task == "RAM-task" and psu_fix_cooldown == true:
		#var rand_index = randi_range(0, len(Global.locker_bin_num_list)-1)
		#print("BIN NUM LIST: ",len(Global.locker_bin_num_list))
#
		#if Global.locker_bin_num_list != []:
			#var task_bin_num = Global.locker_bin_num_list[rand_index]
			#Global.locker_bin_num_list.remove_at(rand_index)
			#task_block.set_task_text(str("Mine võta SSD majast fail asukoha aadressiga kahendkoodis ", task_bin_num), random_task, task_bin_num)
			## ülesande salvestamine sõnastikku, stseeni uuesti laadimisel esitamiseks
			##Global.task_menu_info_dict[str(loendaja) + random_task] = []
			##Global.task_menu_info_dict[str(loendaja) + random_task].append(str("Mine võta SSD majast fail asukoha aadressiga ", task_bin_num))
			#Global.task_menu_info_dict[task_bin_num] = []
			#Global.task_menu_info_dict[task_bin_num].append(str("Mine võta SSD majast fail asukoha aadressiga kahendkoodis ", task_bin_num))
			#Global.task_menu_info_dict[task_bin_num].append(task_bin_num)
			#
			#
			##loendaja += 1
		#else:
			#task_block.set_task_text(str("Kõik SSD üledanded tehtud!"), random_task, "task_information")
	#elif random_task == "RAM-task":
		#task_block.set_task_text(str("Vii *see fail* RAM majja"), random_task, "task_info")
		#psu_fix_cooldown = true
		#Global.task_menu_info_dict[str(loendaja) + " " + random_task] = []
		#Global.task_menu_info_dict[str(loendaja) + " " + random_task].append(str("Vii *see fail* RAM majja"))
		#Global.task_menu_info_dict[str(loendaja) + " " + random_task].append("task_info")
		#loendaja += 1
		#
#
#func load_tasks():
	#for el in Global.task_menu_info_dict:
		#var task_block = preload("res://task_block.tscn").instantiate()
		#$Task_Panel/ScrollContainer/VBoxContainer.add_child(task_block)
		#task_block.set_task_text(str(Global.task_menu_info_dict[el][0]),  el, Global.task_menu_info_dict[el][1])
		#
		#print("Global.task_bin_num: ",Global.task_bin_num)
		##print("Selle split: ", Global.task_bin_num.split(" "))
		##print(Global.task_bin_num.split(" ")[len(Global.task_bin_num)-1], "==", el)
		#if Global.task_bin_num == el and Global.task_bin_num != null:
			#task_block.set_task_started()
			#task_block.modulate = "ffffb2" # hele-kollane
#
#
#func random_binary_num():
	#var number_found = false
	#var randbin_nums
	#while number_found == false:
		#randbin_nums = ["1"]
		#for i in randi_range(1, 9):
			#var temp = str(randi_range(0, 1))
	 		#
			#randbin_nums.append(temp)
		#var randbin_num = "".join(randbin_nums)
		#if randbin_num not in Global.all_randbin_nums:
			#Global.all_randbin_nums.append(randbin_num)
			#number_found = true
	#return "".join(randbin_nums)
		##else:
			##print("RANDOM ELSE")
			##random_binary_num()
#
#func set_cycle_state(): #
	#$Cycle_Panel/Selection_Panel.show() #
#
## CPU töö tsükli nupud
#
#func _on_button_fetching_button_down():
	#$"Cycle_Panel/Block_hankimine/Label".set_vertical_alignment(3)
	#$"Cycle_Panel/Block_hankimine/more_info".show()
	#
#func _on_button_fetching_button_up():
	#$"Cycle_Panel/Block_hankimine/Label".set_vertical_alignment(1)
	#$"Cycle_Panel/Block_hankimine/more_info".hide()
#
#
#
#func _on_button_decoding_button_down():
	#$"Cycle_Panel/Block_dekodeerimine/Label".set_vertical_alignment(3)
	#$"Cycle_Panel/Block_dekodeerimine/more_info".show()
	#
#func _on_button_decoding_button_up():
	#$"Cycle_Panel/Block_dekodeerimine/Label".set_vertical_alignment(1)
	#$"Cycle_Panel/Block_dekodeerimine/more_info".hide()
#
#
#
#func _on_button_executing_button_down():
	#$"Cycle_Panel/Block_sooritamine/Label".set_vertical_alignment(3)
	#$"Cycle_Panel/Block_sooritamine/more_info".show()
	#
#func _on_button_executing_button_up():
	#$"Cycle_Panel/Block_sooritamine/Label".set_vertical_alignment(1)
	#$"Cycle_Panel/Block_sooritamine/more_info".hide()
	#
#
#
#
#
##func _on_new_task_btn_pressed():
##	new_task()
