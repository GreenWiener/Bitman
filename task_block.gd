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
		Global.task_menu_info_dict[task_type][3] = "finished"
		Global._task_menu.new_task("deliver-SSD-info", "pooleli")
		if Global.helparrow_state == "done_1st_task": # lisa HelpArrow aitamaks mängijal oma punktid claimida
			if Global._player.task_menu.visible == true: # kui mängijal on task_menu juba lahti, skipi üks HelpArrow state
				Global.helparrow_state == "done_1st_taskblock"
				Global.add_HelpArrow(Global._player.task_menu, Vector2(-4, 40), 1)
			else:
				Global.add_HelpArrow(Global._player.get_node("CanvasLayer/Buttons/SideButtons/task_btn"), Vector2(-12,20), 2)
	
	if "deliver-SSD-info" in task_type and Global.task_ram_finished == true and finished_task == false:
		set_task_finished()
		Global.finished_task = true
		Global.task_ram_finished = false
		Global.task_ram_done = task_type
		Global.delivered_ram_items.append(Global.deliver_ram_item)
		Global.deliver_cpu_item = Global.deliver_ram_item + " info"
		Global.deliver_ram_item = null
		Global.task_menu_info_dict[task_type][3] = "finished"
		Global._task_menu.new_task("deliver-RAM-info", "pooleli")
	
	if "deliver-RAM-info" in task_type and Global.task_cpu_finished == true and finished_task == false:
		Global.finished_task = true
		Global.task_cpu_finished = false
		set_task_finished()
		Global.delivered_cpu_items.append(Global.deliver_cpu_item)
		Global.deliver_cpu_item = null
		Global.task_cpu_done = task_type
		Global.task_ongoing = false
		Global.task_menu_info_dict[task_type][3] = "finished"
		Global._controlpanel.reload_queued = true
		Global.task_dec_num = ""
		Global._task_menu.new_task("locate-SSD-info", "new")
		

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
#func _on_yes_btn_pressed(): ###############################################
	#yes_or_no_label.hide()
	if task_started == false and Global.task_ongoing == false: # and Global.task_bin_num == null
		start_task()
		
	else:
		warning_menu.visible = true
		



func _on_finish_btn_pressed():
	#ok_btn.hide()
	#if Global.helparrow_state == "done_1st_taskblock":
		#Global.remove_HelpArrow(Global._player.get_node("CanvasLayer/SideButtons/Control/task_menu"))
	#if finished_task == true:
	print("+1 points")
	Global.player_task_level_points += 10
	Global._player.points_particles()
	giveup_task()
	Global.finished_task = false ############# ?


var calculated_dec_num

func start_task():
	set_task_started()
	Global.task_ongoing = true
	Global.task_menu_info_dict[task_type][3] = "pooleli" ###### MÜSTILINE ERROR VAHEL!!!!!!!!!!!!!!!
	#for el in Global.task_menu_info_dict:
		#if Global.task_menu_info_dict[el][3] == "":
			#Global.task_menu_info_dict[el][3] = "pooleli"
			#print("it is")
	status_text.text = "alustatud"
	print(">STARTED TASK2: ", task_type, ", ", Global.task_menu_info_dict)
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


func set_task_text(set_task_type, set_the_text, set_task_info):
	task_type = set_task_type
	task_info = set_task_info
	task_infotext.text = set_the_text
	
	if Global.language == "english":
		if "locate-SSD-info" in task_type:
			task_title.text = "SSD house task"
		if "deliver-SSD-info" in task_type:
			task_title.text = "RAM house task"
		if "deliver-RAM-info" in task_type:
			task_title.text= "CPU house task"
	elif Global.language == "skibidi":
		if "locate-SSD-info" in task_type:
			task_title.text = "skibidi SSD"
		if "deliver-SSD-info" in task_type:
			task_title.text = "skibidi RAM"
		if "deliver-RAM-info" in task_type:
			task_title.text= "skibidi CPU"
	else:
		if "locate-SSD-info" in task_type:
			task_title.text = "SSD-maja ülesanne"
		if "deliver-SSD-info" in task_type:
			task_title.text = "RAM-maja ülesanne"
		if "deliver-RAM-info" in task_type:
			task_title.text= "CPU-maja ülesanne"


func set_task_started():
	task_started = true
	status_text.text = "pooleli"
	status_text.modulate = "ffff00" # kollane
	expand_indicator_label.modulate = "ffff00"
	buttons_container.hide()
	start_btn.hide()
	help_btn.visible = true

func set_task_finished():
	print("FINNISHED: ", task_type)
	finished_task = true
	status_text.text = "tehtud"
	status_text.modulate = "00ff00" # roheline
	expand_indicator_label.modulate = "00ff00"
	buttons_container.show()
	start_btn.hide()
	finish_btn.show()
	


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



var expand_mode = false
func _on_expand_btn_pressed():
	info_container.visible = !info_container.visible
	if expand_mode == false:
		expand_indicator_label.rotation_degrees = 90
	else:
		expand_indicator_label.rotation_degrees = 0
	expand_mode = !expand_mode
	
	if Global.helparrow_state == "taskblock" or Global.helparrow_state == "done_1st_taskblock" or Global.helparrow_state == "done_1st_task":
		Global.remove_HelpArrow(Global._player.task_menu)
	


func _on_help_btn_pressed():
	help_menu.visible = true



func _on_yes_btn_pressed():
	help_menu.visible = false
	var new_task_name = task_type.erase(0, 2)
	Global._task_menu.new_task(new_task_name, "new")
	giveup_task()


func _on_no_btn_pressed():
		help_menu.visible = false

func _on_ok_btn_pressed():
	warning_menu.visible = false
