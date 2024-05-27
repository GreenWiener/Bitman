extends RichTextLabel

var task_type = ""
var task_info

var task_started = false
var finished_task = false


func _process(_delta):
	# locate-SSD-info ülesande lõpetamine
	if "locate-SSD-info" in task_type and Global.task_ssd_finished == true and finished_task == false:
		set_task_finished()
		Global.finished_task = true
		Global.task_ssd_finished = false
		Global.task_bin_num = null ###
		Global.bin_task_completed_last = null ###
		Global.task_ssd_done = task_type
		Global.deliver_ram_item = Global.box_item
		Global.task_menu_info_dict[task_type][2] = "finished"
		Global._task_menu.new_task("deliver-SSD-info", "started")
		Global.add_HelpArrow(Global._player.get_node("CanvasLayer"), Global._player.get_node("CanvasLayer/task_btn").position - Vector2(10,-7))
	
	if "deliver-SSD-info" in task_type and Global.task_ram_finished == true and finished_task == false:
		set_task_finished()
		Global.finished_task = true
		Global.task_ram_finished = false
		Global.task_ram_done = task_type
		Global.delivered_ram_items.append(Global.deliver_ram_item)
		Global.deliver_cpu_item = Global.deliver_ram_item + " info"
		Global.task_menu_info_dict[task_type][2] = "finished"
		Global._task_menu.new_task("deliver-RAM-info", "started")
	
	if "deliver-RAM-info" in task_type and Global.task_cpu_finished == true and finished_task == false:
		Global.finished_task = true
		Global.task_cpu_finished = false
		set_task_finished()
		Global.deliver_ram_item = null
		Global.delivered_cpu_items.append(Global.deliver_cpu_item)
		Global.deliver_cpu_item = null
		Global.task_cpu_done = task_type
		Global.task_ongoing = false
		Global.task_menu_info_dict[task_type][2] = "finished"
		Global._controlpanel.reload_queued = true
		Global.task_dec_num = ""
		Global._task_menu.new_task("locate-SSD-info", "new")


func _on_button_task_pressed():
	if Global.task_ongoing == false and task_started == false and Global.task_menu_info_dict[task_type][2] != "finished":
		print("task_typEEEEEEE-: ", task_type)
		$yes_or_no.text = "                 Alusta ülesanne?"
		$yes_or_no.show()
	
	elif finished_task == true:
		$ok.text = "              Ülesanne on tehtud!\n              +10 punkti"
		$ok.show()
	
	elif task_started == true:
		$yes_or_no.text = "    Ülesanne pooleli. Annad alla?"
		$yes_or_no.show()
	
	elif Global.finished_task == true and task_started == false:
		$ok.text = "             Lõpeta eelmine ülesanne!"
		$ok.show()
	
	else:
		$ok.text = "    Oled juba ühe ülesande alustanud!"
		$ok.show()


func _on_yes_btn_pressed():
	$yes_or_no.hide()
	if task_started == false: # and Global.task_bin_num == null
		start_task()
		if Global.helparrow_state == "taskblock":
			Global.remove_HelpArrow(Global._player.get_node("CanvasLayer/task_menu"))
	else:
		if task_started == false: # and Global.task_bin_num != null
			$ok.text = "    Oled juba ühe ülesande alustanud!"
			$ok.show()
			
		elif task_started == true:
			task_started = false
			giveup_task()
		
		
func _on_no_btn_pressed():
	$yes_or_no.hide()

func _on_ok_btn_pressed():
	$ok.hide()
	if Global.helparrow_state == "done_1st_taskblock":
		Global.remove_HelpArrow(Global._player.get_node("CanvasLayer/task_menu"))
	if finished_task == true:
		print("+1 points")
		Global.player_task_level_points += 10
		giveup_task()
		Global.finished_task = false ############# ?



var calculated_dec_num

func start_task():
	Global.task_ongoing = true
	task_started = true
	self.modulate = "ffffb2" # hele-kollane
	print(">STARTED TASK: ", task_type)
	Global.task_menu_info_dict[task_type][2] = "pooleli"
	
	if "locate-SSD-info" in task_type:  ##############################################
		Global.task_bin_num = task_info
		# kümnendarvu arvutamine
		Global.task_bin_num_in_dec = calc_decimal_num(task_info)
		Global.task_ssd_pooleli = task_type

	if "deliver-SSD-info" in task_type:
		Global.task_ram_pooleli = task_type
	if "deliver-RAM-info" in task_type:
		Global.task_cpu_pooleli = task_type



func calc_decimal_num(bin_num):
	calculated_dec_num = 0
	var aste = len(bin_num)-1
	for i in bin_num:
		var calculation = int(i) * 2 ** aste
		calculated_dec_num += calculation
		aste -= 1
	
	return calculated_dec_num


func set_task_text(set_the_text, set_task_type, set_task_info):
	task_type = set_task_type
	task_info = set_task_info
	self.text = set_the_text


func set_task_started():
	task_started = true

func set_task_finished():
	print("FINNISHED")
	self.modulate = "6eff66" # hele-roheline
	finished_task = true


func giveup_task():
	print("⬛⬛⬛|||>>>--- GIVEUP_TASK() ---<<<|||⬛⬛⬛😩")
	Global.task_ongoing = false
	
	Global.task_menu_info_dict.erase(task_type)

	if "locate-SSD-info" in task_type:
		Global.task_ssd_pooleli = ""
		Global.task_ssd_finished = false
		Global.task_ssd_done = ""
		Global.task_bin_num = null #??
	if "deliver-SSD-info" in task_type:
		Global.task_ram_pooleli = ""
		Global.task_ram_finished = false
		Global.task_ram_done = ""
	if "deliver-RAM-info" in task_type:
		Global.task_cpu_pooleli = ""
		Global.task_cpu_finished = false
		Global.task_cpu_done = ""
	queue_free()



