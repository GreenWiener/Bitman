extends Control

@onready var TaskLabel = $PanelContainer/Task_Panel/TaskLabel

func _ready():
	Global._task_menu = self
	load_tasks()
	
	if Global.task_menu_first_task == false:
		new_task("SSD-task", "new")
		Global.task_menu_first_task = true

	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()
#func _process(delta):
#	if Global.bin_task_finished ==  GREEN

func lang_english():
	TaskLabel.text = "Tasks"

func lang_skibidi():
	TaskLabel.text = "Skibidi tasks"
	

var a_task_cooldown = false

var task_bin_num

var task_name
var unique_task_name
#var loendaja = 1

func new_task(task, state):
	# vali suvaline task
	if task == "random":
		task_name = Global.tasks[randi() % Global.tasks.size()] # valib suvalise ülesande listist Global.tasks = ["SSD-task","RAM-task",,"CPU-task"]
	else:
		task_name = task
	
	var task_block = preload("res://task_block.tscn").instantiate()
	$PanelContainer/Task_Panel/ScrollContainer/VBoxContainer.add_child(task_block)
	
	var lang_task_str = ""
	if Global.language == "english":
		lang_task_str = "Solving this task will give you 10 points!"
	elif Global.language == "skibidi":
		lang_task_str = "Solving this task will give you 10 points"
	else:
		lang_task_str = "Lahendades selle ülesande saad 10 punkti!"

	# kindlad taskid
	if task_name == "SSD-task": #--------# SSD #--------------------------------#
		var rand_index = randi_range(0, len(Global.locker_bin_num_list)-1)
		print("rand_index--", rand_index)
		print("Global.locker_bin_num_list[rand_index]--", Global.locker_bin_num_list[rand_index])
		task_bin_num = Global.locker_bin_num_list[rand_index]
		Global.locker_bin_num_list.remove_at(rand_index)
		#set_task_text(set_task_type, set_the_text, set_task_info)
		unique_task_name = str(Global.unique_task_id, " ", task_name)
		
		
		task_block.set_task_text(unique_task_name, lang_task_str, task_bin_num)
		# ülesande salvestamine sõnastikku, stseeni uuesti laadimisel esitamiseks
		Global.task_menu_info_dict[unique_task_name] = ["","","",""]
		Global.task_menu_info_dict[unique_task_name][0] = unique_task_name
		Global.task_menu_info_dict[unique_task_name][1] = lang_task_str
		Global.task_menu_info_dict[unique_task_name][2] = task_bin_num
		Global.unique_task_id += 1

	elif task_name == "RAM-task": #--------# RAM #--------------------------------#
		unique_task_name = str(Global.unique_task_id, " ", task_name)
		task_block.set_task_text(unique_task_name, lang_task_str, Global.box_item)
		Global.task_menu_info_dict[unique_task_name] = ["","","",""]
		Global.task_menu_info_dict[unique_task_name][0] = unique_task_name
		Global.task_menu_info_dict[unique_task_name][1] = lang_task_str
		Global.task_menu_info_dict[unique_task_name][2] = Global.box_item
		Global.unique_task_id += 1

	elif task_name == "CPU-task": #--------# CPU #--------------------------------#
		unique_task_name = str(Global.unique_task_id, " ", task_name)
		task_block.set_task_text(unique_task_name, lang_task_str, Global.deliver_cpu_item)
		Global.task_menu_info_dict[unique_task_name] = ["","","",""]
		Global.task_menu_info_dict[unique_task_name][0] = unique_task_name
		Global.task_menu_info_dict[unique_task_name][1] = lang_task_str
		Global.task_menu_info_dict[unique_task_name][2] = Global.deliver_cpu_item
		Global.unique_task_id += 1

	if state == "pooleli":
		task_block.start_task()
	elif state == "finished":
		task_block.set_task_completed()




func load_tasks():
	for el in Global.task_menu_info_dict:
		var task_block = preload("res://task_block.tscn").instantiate()
		$PanelContainer/Task_Panel/ScrollContainer/VBoxContainer.add_child(task_block)
		
		task_block.set_task_text(Global.task_menu_info_dict[el][0],  Global.task_menu_info_dict[el][1], Global.task_menu_info_dict[el][2])
	
		# POOLELI
		if Global.task_menu_info_dict[el][3] == "pooleli":
			task_block.set_task_started()
			#task_block.modulate = "ffffb2" # hele-kollane

		# TEHTUD (aga mitte lõpetatud)
		if Global.task_menu_info_dict[el][3] == "finished":
			task_block.set_task_completed()
			#task_block.modulate = "6eff66" # hele-roheline
		

func random_binary_num():
	var number_found = false
	var randbin_nums
	while number_found == false:
		randbin_nums = ["1"]
		for i in randi_range(1, 3): ##### !!! 1, 9
			var temp = str(randi_range(0, 1))
	 		
			randbin_nums.append(temp)
		var randbin_num = "".join(randbin_nums)
		if randbin_num not in Global.all_randbin_nums:
			Global.all_randbin_nums.append(randbin_num)
			number_found = true
	return "".join(randbin_nums)
		#else:
			#print("RANDOM ELSE")
			#random_binary_num()




func _on_new_task_btn_pressed():
	new_task("random", "new")


func toggle_newtask_btn():
	$PanelContainer/Task_Panel/new_task_btn.visible = !$PanelContainer/Task_Panel/new_task_btn.visible































## Called when the node enters the scene tree for the first time.
#func _ready():
	#Global._task_menu = self
	#setTask()
#
#
#
#var SSD_locations = ["Chrome.exe","VLC.exe","file.txt","file.mp3","file.mp4"]	
#
#
#func newTask():
	#var index_tasks = int(randf_range(0, len(Global.tasks)))
	#var index_SSD_locations = int(randf_range(0, len(SSD_locations)))
#
	##$tasks.text += Global.tasks[index] + "\n"
	#var task_name = Global.tasks[index_tasks]
	#Global.selected_task = task_name # salvesta info Globalisse
	#var _SSD_location = SSD_locations[index_SSD_locations]
	#Global.task_SSD_location = _SSD_location  # salvesta info Globalisse
	#
#func setTask():
	#var task_node = CheckBox.new()
	#$PanelContainer/TasksContainer.add_child(task_node)
	#task_node.mouse_filter = Control.MOUSE_FILTER_IGNORE	
	##task_node.theme_override_font_sizes/font_size = 10 ?????????
	##task_node.text += task_name + "\n"	
#
	#if Global.selected_task == "SSD-to-RAM":
		#task_node.text += "Leia SSD majast " + Global.task_SSD_location + " ja vii see RAM-i\n"
	#if Global.selected_task == "RAM-task":
		#task_node.text += "Paranda PSU port emaplaadil\n"
#
#func completeTask():
	#$PanelContainer/TasksContainer/CheckBox.text = "step 1 DONE"
#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass



var disable_zoom = false
func _on_zoom_ignore_area_mouse_entered():
	disable_zoom = true

func _on_zoom_ignore_area_mouse_exited():
	disable_zoom = false
