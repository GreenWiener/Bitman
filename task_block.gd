extends PanelContainer

var task_type = ""
var task_info

var task_started = false
var finished_task = false

@onready var task_title = $VBoxContainer/TitleContainer/task_title
@onready var task_infotext = $VBoxContainer/TaskInfo_container/InfoContainer/task_info
@onready var yes_or_no_label = $VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/YesNoContainer
@onready var ok_btn = $VBoxContainer/TaskInfo_container/Warning_menu/WarningContainer/YesNoContainer/ok_btn
@onready var buttons_container = $VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container
@onready var start_btn = $VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/start_btn
@onready var finish_btn = $VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/finish_btn
@onready var status_text = $VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/status_status
@onready var expand_indicator_label = $VBoxContainer/TitleContainer/expand_indicator/expand_indicator_label
@onready var help_menu = $VBoxContainer/TaskInfo_container/Help_menu
@onready var warning_menu = $VBoxContainer/TaskInfo_container/Warning_menu
@onready var info_container = $VBoxContainer/TaskInfo_container/InfoContainer
@onready var help_btn = $VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/HelpButton/help_btn

func _ready():
	info_container.visible = false
	help_menu.visible = false
	warning_menu.visible = false
	help_btn.visible = false
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()

func _process(_delta):
	if task_type == Global.task_ongoing:
		if "SSD-task" in task_type and Global.task_ssd_done != task_type:
			if Global.subtask < len(Global._task_bar.SSD_subtasks):
				task_infotext.text = Global._task_bar.SSD_subtasks[Global.subtask]
		if "RAM-task" in task_type and Global.task_ram_done != task_type:
			if Global.subtask < len(Global._task_bar.RAM_subtasks):
				task_infotext.text = Global._task_bar.RAM_subtasks[Global.subtask]
		if "CPU-task" in task_type and Global.task_cpu_done != task_type:
			if Global.subtask < len(Global._task_bar.CPU_subtasks):
					task_infotext.text = Global._task_bar.CPU_subtasks[Global.subtask]
			if Global.subtask == -1:
				task_infotext.text = "Lindile pandud ese polnud ülesandes nõutud ese või polnud kasti sees. Sõida RAM-majja tagasi ja võta õigel kujul info või anna see ülesanne alla, vajutades üleval olevale rohelisele küsimärgile."
				if Global.language == "english":
					task_infotext.text = "The scanned item did not match the conditions of the task.\nTry again or get a new task from the task menu."
				elif Global.language == "skibidi":
					task_infotext.text = "The scanned item did not match the conditions of the task.\nTry again or get a new task from the task menu."
				else:
					task_infotext.text = "Lindile pandud ese polnud ülesandes nõutud ese või polnud kasti sees. Sõida RAM-majja tagasi ja võta õigel kujul info või anna see ülesanne alla, vajutades üleval olevale rohelisele küsimärgile."
				
			if Global.subtask == -2:
				if Global.language == "english":
					task_infotext.text = "You made a conversion error. Try again. If necessary,\nread the decimal to binary conversion guide."
				elif Global.language == "skibidi":
					task_infotext.text = "You made a conversion error. Try again. If necessary,\nread the decimal to binary conversion guide."
				else:
					task_infotext.text = "Tegid teisendusel vea. Proovi uuesti. Vajadusel loe põhjalikult ja kenasti aju kasutades kümnendarvu kahendarvuks teisendamise juhendit. Pea meeles, et vastust loetakse alt ülesse!"
				
				
			if Global.subtask == -3: # ei tööta, aga ei koti eriti kah
				task_infotext.text = "Lahenduses on viga. Vaata üle, et ikka õiget arvu jagama hakkad! Iga rea alguses peab olema eelmiselt realt võetud kahega korrutatava arvu täisarv. Loe juhendid johhaidii!"
			if Global.subtask == -4:
				if Global.language == "english":
					task_infotext.text = "The remainders are incorrect.\nRemember that the remainder must be either 1 or 0."
				elif Global.language == "skibidi":
					task_infotext.text = "The remainders are incorrect.\nRemember that the remainder must be either 1 or 0."
				else:
					task_infotext.text = "Lahenduse tulemusel arvutatavad jäägid on valed. Pea meeles, et jääk peab tulema kas 1 või 0. Pole nii raske ju."
				
			if Global.subtask == -5:
				if Global.language == "english":
					task_infotext.text = "The answer you entered is incorrect. Remember to\nread the answers from the bottom to top!"
				elif Global.language == "skibidi":
					task_infotext.text = "The answer you entered is incorrect. Remember to\nread the answers from the bottom to top!"
				else:
					task_infotext.text = "Sisestatud vastus on vale. Pea meeles, et vastust loetakse alt ülesse!"
	
		Global.task_ongoing_block = self
		
		
func complete_ssd_task():
	# SSD-task ülesande lõpetamine
	#if "SSD-task" in task_type and Global.task_ssd_finished == true and finished_task == false:
	#Global.finished_task = true
	#Global.task_ssd_finished = false
	

	Global.task_ssd_done = task_type
	Global.deliver_ram_item = Global.box_item # for next task
	Global.task_menu_info_dict[task_type][3] = "finished"
	Global._task_menu.new_task("RAM-task", "pooleli")
	if Global.language == "english" or Global.language == "skibidi":
		Global._task_bar.set_done_text("SSD house task", "Task completed!")
	else:
		Global._task_bar.set_done_text("SSD-maja ülesanne", "Ülesanne tehtud!")
	AudioPlayer.play_fx("res://audio/task_done.wav")
	set_task_completed()
	
	#if Global.helparrow_state == "done_1st_task": # lisa HelpArrow aitamaks mängijal oma punktid claimida
		#if Global._player.task_menu.visible == true: # kui mängijal on task_menu juba lahti, skipi üks HelpArrow state
			#Global.helparrow_state == "done_1st_taskblock"
			#Global.add_HelpArrow(Global._player.task_menu, Vector2(-4, 40), 1)
		#else:
			#Global.add_HelpArrow(Global._player.get_node("CanvasLayer/Buttons/SideButtons/task_btn"), Vector2(-12,20), 2)

func complete_ram_task():
	#if "RAM-task" in task_type and Global.task_ram_finished == true and finished_task == false:
	#Global.finished_task = true
	#Global.task_ram_finished = false
	
	Global.task_ram_done = task_type
	Global.delivered_ram_items.append(Global.deliver_ram_item)
	Global.deliver_cpu_item = Global.deliver_ram_item
	Global.deliver_ram_item = null
	Global.task_menu_info_dict[task_type][3] = "finished"
	Global._task_menu.new_task("CPU-task", "pooleli")
	if Global.language == "english" or Global.language == "skibidi":
		Global._task_bar.set_done_text("RAM house task", "Task completed!")
	else:
		Global._task_bar.set_done_text("RAM-maja ülesanne", "Ülesanne tehtud!")
	AudioPlayer.play_fx("res://audio/task_done.wav")
	set_task_completed()
	
func complete_cpu_task():
	#if "CPU-task" in task_type and Global.task_cpu_finished == true and finished_task == false:
	#Global.finished_task = true
	#Global.task_cpu_finished = false
	
	Global.task_dec_num = ""
	#####Global.delivered_cpu_items.append(Global.deliver_cpu_item) # tee seda teises kohas 
	Global.deliver_cpu_item = null
	Global.task_cpu_done = task_type
	Global.task_menu_info_dict[task_type][3] = "finished"
	Global._controlpanel.reload_queued = true
	Global._task_menu.new_task("SSD-task", "new")
	if Global.language == "english" or Global.language == "skibidi":
		Global._task_bar.set_done_text("CPU house task", "Task completed!")
	else:
		Global._task_bar.set_done_text("CPU-maja ülesanne", "Ülesanne tehtud!", true)
	AudioPlayer.play_fx("res://audio/task_done.wav")
	set_task_completed()
	

#func _on_button_task_pressed():
	#if Global.task_ongoing == false and task_started == false and Global.task_menu_info_dict[task_type][2] != "finished":
		#print("task_typEEEEEEE-: ", task_type)
		#yes_or_no_label.text = "                 Alusta ülesanne?"
		#yes_or_no_label.show()
	#
	#elif finished_task == true:
		#ok_btn.text = "              Ülesanne on tehtud!\n              +10 punkti"
		#ok_btn.show()
	#
	#elif task_started == true:
		#yes_or_no_label.text = "    Ülesanne pooleli. Annad alla?"
		#yes_or_no_label.show()
	#
	#elif Global.finished_task == true and task_started == false:
		#ok_btn.text = "             Lõpeta eelmine ülesanne!"
		#ok_btn.show()
	#
	#else:
		#ok_btn.text = "    Oled juba ühe ülesande alustanud!"
		#ok_btn.show()


func _on_start_btn_pressed():
	AudioPlayer.play_fx("res://audio/menu_click1.wav")
#func _on_yes_btn_pressed(): ###############################################
	#yes_or_no_label.hide()
	if task_started == false and Global.task_ongoing == "": # and Global.task_bin_num == null
		start_task()
		
	else:
		warning_menu.visible = true
		



func _on_finish_btn_pressed():
	#ok_btn.hide()
	#if Global.helparrow_state == "done_1st_taskblock":
		#Global.remove_HelpArrow(Global._player.get_node("CanvasLayer/SideButtons/Control/task_menu"))
	#if finished_task == true:
	if task_type == Global.task_ongoing:
		print("AAYEPPPPPPPPPPPPP")
		#Global.task_bin_num = null
	##Global.bin_task_completed_last = null
	print("+1 points")
	Global.player_task_level_points += 10
	Global._player.points_particles()
	AudioPlayer.play_fx("res://audio/points_earned.wav")
	giveup_task()
	Global.finished_task = false ############# ?


var calculated_dec_num

func start_task():
	set_task_started()
	Global.task_ongoing = task_type
	Global.task_menu_info_dict[task_type][3] = "pooleli" ###### MÜSTILINE ERROR VAHEL!!!!!!!!!!!!!!!
	#for el in Global.task_menu_info_dict:
		#if Global.task_menu_info_dict[el][3] == "":
			#Global.task_menu_info_dict[el][3] = "pooleli"
			#print("it is")
	Global.subtask = 0
	if Global.language == "english":
		status_text.text = "started"
	elif Global.language == "skibidi":
		status_text.text = "skibiding"
	else:
		status_text.text = "alustatud"
	
	print(">STARTED TASK2: ", task_type, ", ", Global.task_menu_info_dict)
	if "SSD-task" in task_type:  ##############################################
		Global.task_bin_num = task_info
		# kümnendarvu arvutamine
		Global.task_bin_num_in_dec = calc_decimal_num(task_info)
		Global.task_ssd_pooleli = task_type
		
		Global.showed_helparrow.append("task1")
		if Global.world_name == "SSD":
			Global._controlpanel.computer_helparrow()
		
	if "RAM-task" in task_type:
		Global.task_ram_pooleli = task_type
	if "CPU-task" in task_type:
		Global.task_cpu_pooleli = task_type
	
	
	
	for el in Global._info_panel:
		if el == null:
			Global._info_panel.erase(el)
		else:
			el.show_helparrow()
	


func calc_decimal_num(bin_num):
	calculated_dec_num = 0
	var aste = len(bin_num)-1
	for i in bin_num:
		var calculation = int(i) * 2 ** aste
		calculated_dec_num += calculation
		aste -= 1
	
	return calculated_dec_num


func set_task_text(set_task_type, set_the_text, set_task_info):
	task_type = set_task_type
	task_info = set_task_info
	task_infotext.text = set_the_text
	
	if Global.language == "english":
		if "SSD-task" in task_type:
			task_title.text = "SSD house task"
		if "RAM-task" in task_type:
			task_title.text = "RAM house task"
		if "CPU-task" in task_type:
			task_title.text= "CPU house task"
	elif Global.language == "skibidi":
		if "SSD-task" in task_type:
			task_title.text = "skibidi SSD"
		if "RAM-task" in task_type:
			task_title.text = "skibidi RAM"
		if "CPU-task" in task_type:
			task_title.text= "skibidi CPU"
	else:
		if "SSD-task" in task_type:
			task_title.text = "SSD-maja ülesanne"
		if "RAM-task" in task_type:
			task_title.text = "RAM-maja ülesanne"
		if "CPU-task" in task_type:
			task_title.text= "CPU-maja ülesanne"


func set_task_started(): # visual
	task_started = true
	
	if Global.language == "english":
		status_text.text = "in progress"
	elif Global.language == "skibidi":
		status_text.text = "almost skibidi"
	else:
		status_text.text = "pooleli"
	
	status_text.modulate = "ffff00" # kollane
	expand_indicator_label.modulate = "ffff00"
	buttons_container.hide()
	start_btn.hide()
	help_btn.visible = true

func set_task_completed(): # visual
	print("FINNISHED: ", task_type)
	finished_task = true
	
	if Global.language == "english":
		status_text.text = "done"
		task_infotext.text = "By completing this task you will earn 10 points"
	elif Global.language == "skibidi":
		status_text.text = "yes"
		task_infotext.text = "By skibiding this task you will earn 1 skibidi rizz"
	else:
		status_text.text = "tehtud"
		task_infotext.text = "Lõpetades selle ülesande saad 10 punkti"
	
	status_text.modulate = "00ff00" # roheline
	expand_indicator_label.modulate = "00ff00"
	buttons_container.show()
	start_btn.hide()
	finish_btn.show()
	help_btn.hide()
	
	


func giveup_task():
	print("⬛⬛⬛|||>>>--- GIVEUP_TASK() ---<<<|||⬛⬛⬛😩")
	if task_type == Global.task_ongoing:
		Global.task_ongoing = ""
	
	Global.task_menu_info_dict.erase(task_type)

	if "SSD-task" in task_type:
		Global.task_ssd_pooleli = ""
		Global.task_ssd_finished = false
		Global.task_ssd_done = ""
		Global.task_bin_num = null #??
		
		if Global.item_name != null:
			if Global.task_ongoing == "" and ("kapi_kood" in Global.item_name or (Global.box_item == Global.deliver_ram_item and Global.box_item != null)):
				Global._player.release_item(null, null)
		
	if "RAM-task" in task_type:
		Global.task_ram_pooleli = ""
		Global.task_ram_finished = false
		Global.task_ram_done = ""
		
		if Global.task_ongoing == "" and (Global.item_name != null and Global.deliver_ram_item != null and Global.item_name == str(Global.deliver_ram_item + " info") or (Global.box_item == Global.deliver_ram_item and Global.box_item != null and Global.deliver_ram_item != null)):
			Global._player.release_item(null, null)
		
	if "CPU-task" in task_type:
		Global.task_cpu_pooleli = ""
		Global.task_cpu_finished = false
		Global.task_cpu_done = ""
		Global.finished_task = true
		Global.task_cpu_finished = false
		Global.task_cpu_done = task_type
		if Global._controlpanel != null:
			Global._controlpanel.reload_queued = true
		Global.task_dec_num = ""
		print("👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽")
		
		if Global.box_item != null:
			if Global.task_ongoing == "" and (("kood - " in Global.box_item) or (Global.box_item == Global.deliver_cpu_item and Global.box_item != null)): # info in box not despawning
				Global._player.release_item(null, null)
		
		Global.deliver_cpu_item = null
		
	queue_free()
	



var expand_mode = false
func _on_expand_btn_pressed():
	AudioPlayer.play_fx("res://audio/bop2.wav")
	info_container.visible = !info_container.visible
	if expand_mode == false:
		expand_indicator_label.rotation_degrees = 90
	else:
		expand_indicator_label.rotation_degrees = 0
	expand_mode = !expand_mode
	
	if Global.helparrow_state == "taskblock" or Global.helparrow_state == "done_1st_taskblock" or Global.helparrow_state == "done_1st_task":
		Global.remove_HelpArrow(Global._player.task_menu)
	


func _on_help_btn_pressed():
	AudioPlayer.play_fx("res://audio/tick.wav")
	help_menu.visible = true



func _on_yes_btn_pressed():
	AudioPlayer.play_fx("res://audio/bop.wav")
	help_menu.visible = false
	giveup_task()
	#var new_task_name = task_type.erase(0, 2)
	if Global._task_binary != null:
		Global._task_binary.kill_scene()
	if Global._task_decimal != null:
		Global._task_decimal.kill_scene()
	
	Global._task_menu.new_task("SSD-task", "new")


func _on_no_btn_pressed():
	AudioPlayer.play_fx("res://audio/tick2.wav")
	help_menu.visible = false

func _on_ok_btn_pressed():
	warning_menu.visible = false






func lang_english():
	$VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/status_label.text = "Status: "
	$VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/start_btn.text = "Start"
	$VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/finish_btn.text = "Finish"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/YesNoContainer/yes_btn.text = "Yes"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/YesNoContainer/no_btn.text = "No"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/help_label.text = "If this task cannot be solved for some reason, you can exchange it for a new task. Do you want a new task?"
	$VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/status_status.text = "not started"

func lang_skibidi():
	$VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/status_label.text = "Status: "
	$VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/start_btn.text = "start"
	$VBoxContainer/TaskInfo_container/InfoContainer/Buttons_container/HBoxContainer/finish_btn.text = "im ready"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/YesNoContainer/yes_btn.text = "Yes"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/YesNoContainer/no_btn.text = "NOOOOOOOOOOOOOO"
	$VBoxContainer/TaskInfo_container/Help_menu/HelpContainer/help_label.text = "If this task cannot be skibidid for some skibidi reason, you can exchange it for a new task. Do you want a new task?"
	$VBoxContainer/TaskInfo_container/InfoContainer/StatusContainer/status_status.text = "not skibidi"










