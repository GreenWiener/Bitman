extends Node2D



func _ready():
	self.visible = false
	Global._task_bar = self
	$task_text_box/task_done_container.visible = false
	
	if Global.language == "english":
		lang_house_ssd = "SSD house task"
		lang_house_ram = "RAM house task"
		lang_house_cpu = "CPU house task"
		$task_text_box/task_done_container/Control/subtask_done.text = "Task completed!"
	elif Global.language == "skibidi":
		lang_house_ssd = "SSD skibidi"
		lang_house_ram = "RAM skibidi"
		lang_house_cpu = "CPU skibidi"
	else:
		lang_house_ssd = "SSD-maja ülesanne"
		lang_house_ram = "RAM-maja ülesanne"
		lang_house_cpu = "CPU-maja ülesanne"

var lang_house_ssd
var lang_house_ram
var lang_house_cpu

var SSD_subtasks = []
var RAM_subtasks = []
var CPU_subtasks = []
var SSD_subtasks_en = []
var RAM_subtasks_en = []
var CPU_subtasks_en = []
var SSD_subtasks_sk = []
var RAM_subtasks_sk = []
var CPU_subtasks_sk = []


var deliver_ram_item_file = ""
var deliver_cpu_item_file = ""

func _process(delta):
	if Global.deliver_ram_item != null and ".file" in Global.deliver_ram_item:
		deliver_ram_item_file = str(Global.deliver_ram_item.replace(".file", ""))
	if Global.deliver_ram_item != null and " info" in Global.deliver_ram_item:
		deliver_ram_item_file = str(Global.deliver_ram_item.replace(" info", ""))
	if Global.deliver_cpu_item != null and " info" in Global.deliver_cpu_item:
		deliver_cpu_item_file = str(Global.deliver_cpu_item.replace(" info", ""))
	
	
	if Global.task_ongoing != "":
		SSD_subtasks = ["Sisene SSD-majja.", "Teisenda kahendarv " + str(Global.task_bin_num) + " kümnendarvuks,\nkasutades SSD-majas olevat arvutit.", "Võta SSD-maja nr " + str(Global.bin_task_completed_last) + " kapist fail,\nkasutades enda käes olevat kapi koodi."]
		RAM_subtasks = ["Mine failiga '" + deliver_ram_item_file + "' RAM-majja.", "Leia koht, kus on võimalik fail\n'" + deliver_ram_item_file + "' kastist välja võtta.", "Aseta fail '" + deliver_ram_item_file + "' ühte RAM-maja kappi.", "Võta faili '" + deliver_ram_item_file + "' info,\nkasutades RAM-majas asuvat arvutit.", "Leia koht, kus saad '" + deliver_ram_item_file + " info'\nkasti sisse pakkida."]
		CPU_subtasks = ["Transpordi '" + deliver_cpu_item_file + " info' CPU-majja.", "Mine rongi peale ja käivita see!", "Sisene CPU-majja.", "Aseta '" + deliver_cpu_item_file + " info' (kasti sees) liikuvale lindile.", "Võta skännerist väljastatud kümnendarvuline kood ja\nteisenda see kahendarvuks, kasutades CPU-majas asuvat arvutit."]
		SSD_subtasks_en = ["Enter SSD house.", "Convert binary number " + str(Global.task_bin_num) + " to decimal\nusing the computer in SSD house.", "Take the file from locker " + str(Global.bin_task_completed_last) + " in SSD house."]
		RAM_subtasks_en = ["Take the '" + deliver_ram_item_file + "' file to RAM house.", "Find an area, where you can unbox the \n'" + deliver_ram_item_file + "' file.", "Place the '" + deliver_ram_item_file + "' file\ninside one of the lockers in RAM house.", "Get the '" + deliver_ram_item_file + "' file info\nby using the computer in RAM house.", "Find an area where you can store\n'" + deliver_ram_item_file + " info' inside a box."]
		CPU_subtasks_en = ["Transport '" + deliver_cpu_item_file + " info' to CPU house.", "Get on the train and start it!", "Enter CPU house.", "Place the '" + deliver_cpu_item_file + " info' on the baggage carousel.", "Take the decimal code from the scanner and convert it\nto binary using the computer in CPU house."]
		SSD_subtasks_sk = ["Skibidi to SSD house.", "Convert binary number " + str(Global.task_bin_num) + " to decimal\nusing the skibidi computer in SSD house.", "Take the file from locker " + str(Global.bin_task_completed_last) + " in SSD house."]
		RAM_subtasks_sk = ["Skibidi the '" + deliver_ram_item_file + "' file to RAM house.", "Find an area, where you can unbox the \n'" + deliver_ram_item_file + "' file.", "Place the '" + deliver_ram_item_file + "' file\ninside one of the lockers in RAM house.", "Get the '" + deliver_ram_item_file + "' file info\nby using the computer in RAM house.", "Find an area where you can store\n'" + deliver_ram_item_file + " info' inside a box."]
		CPU_subtasks_sk = ["Skibidi '" + deliver_cpu_item_file + " info' to CPU house.", "Get on the train and skedaddle!", "Enter CPU house.", "Place the '" + deliver_cpu_item_file + " info' on the skibidi carousel.", "Do the thing, you know."]
		
		#if Global.task_ongoing != "": # kui mingi ülesanne on alustatud
		#SSD_subtasks = ["Sisene SSD-majja.", "Teisenda kahendarv " + str(Global.task_bin_num) + " kümnendarvuks,\nkasutades SSD-majas olevat arvutit.",
			#"Võta SSD-maja nr " + str(Global.bin_task_completed_last) + " kapist fail,\nkasutades enda käes olevat kapi koodi."]
		#RAM_subtasks = ["Mine failiga '" + deliver_ram_item_file + "' RAM-majja.", "Leia koht, kus on võimalik fail\n'" + deliver_ram_item_file + 
			#"' kastist välja võtta.", "Aseta fail '" + deliver_ram_item_file + "' ühte RAM-maja kappi.", "Võta faili '" + deliver_ram_item_file + 
			#"' info,\nkasutades RAM-majas asuvat arvutit.", "Leia koht, kus saad '" + deliver_ram_item_file + " info'\nkasti sisse pakkida."]
		#CPU_subtasks = ["Transpordi '" + deliver_cpu_item_file + " info' CPU-majja.", "Mine rongi peale ja käivita see!", "Sisene CPU-majja.", 
			#"Aseta '" + deliver_cpu_item_file + " info' (kasti sees) liikuvale lindile.", "Võta skännerist väljastatud kümnendarvuline kood ja
			#\nteisenda see kahendarvuks, kasutades CPU-majas asuvat arvutit."]
		
		
		if Global.language == "english":
			SSD_subtasks = SSD_subtasks_en
			RAM_subtasks = RAM_subtasks_en
			CPU_subtasks = CPU_subtasks_en
		elif Global.language == "skibidi":
			SSD_subtasks = SSD_subtasks_sk
			RAM_subtasks = RAM_subtasks_sk
			CPU_subtasks = CPU_subtasks_sk
		
		if Global._player.task_menu_open == false:
			self.visible = true
		if "SSD-task" in Global.task_ongoing: #----------
			$task_text_box/VBoxContainer/task_heading.text = lang_house_ssd
			if Global.subtask < len(SSD_subtasks):
				$task_text_box/VBoxContainer/Control/subtask_label.text = SSD_subtasks[Global.subtask]
				$task_text_box/VBoxContainer/subtask_label_ph.text = SSD_subtasks[Global.subtask]
			
			if Global.world_name == "SSD" and Global.subtask == 0:
				next_subtask()
			
			
		if "RAM-task" in Global.task_ongoing: #----------
			$task_text_box/VBoxContainer/task_heading.text = lang_house_ram
			if Global.subtask < len(RAM_subtasks):
				$task_text_box/VBoxContainer/Control/subtask_label.text = RAM_subtasks[Global.subtask]
				$task_text_box/VBoxContainer/subtask_label_ph.text = RAM_subtasks[Global.subtask]
			
			if Global.world_name == "RAM" and Global.subtask == 0:
				next_subtask()
			
			
			
		if "CPU-task" in Global.task_ongoing: #----------
			$task_text_box/VBoxContainer/task_heading.text= lang_house_cpu
			if Global.subtask < len(CPU_subtasks):
				$task_text_box/VBoxContainer/Control/subtask_label.text = CPU_subtasks[Global.subtask]
				$task_text_box/VBoxContainer/subtask_label_ph.text = CPU_subtasks[Global.subtask]
				
			
			if Global.world_name == "MOBO" and Global.subtask == 0:
				next_subtask()
			
			if Global.world_name == "CPU" and (Global.subtask == 2 or Global.subtask == 1):
				next_subtask(3)
			

			var subtask_cpu_text = ""
			
			if Global.subtask == -1:
				if Global.language == "english":
					subtask_cpu_text = "The scanned item did not match the conditions of the task.\nTry again or get a new task from the task menu."
				elif Global.language == "skibidi":
					subtask_cpu_text = "The scanned item wasn't very skibidi.\nTry again or don't."
				else:
					subtask_cpu_text = "Lindile pandud ese ei sobitunud ülesande tingimustega.\nProovi veel või võta ülesannete menüüst uus ülesanne."
				
				$task_text_box/VBoxContainer/Control/subtask_label.text = subtask_cpu_text
				$task_text_box/VBoxContainer/subtask_label_ph.text = subtask_cpu_text
			if Global.subtask == -2:
				if Global.language == "english":
					subtask_cpu_text = "You made a conversion error. Try again. If necessary,\nread the decimal to binary conversion guide."
				elif Global.language == "skibidi":
					subtask_cpu_text = "You made a skibidi error. Try again. If necessary,\nread the decimal to binary conversion guide."
				else:
					subtask_cpu_text = "Tegid teisendusel vea. Proovi uuesti. Vajadusel loe\nkümnendarvu kahendarvuks teisendamise juhendit."
				
				$task_text_box/VBoxContainer/Control/subtask_label.text = subtask_cpu_text
				$task_text_box/VBoxContainer/subtask_label_ph.text = subtask_cpu_text
				
			if Global.subtask == -3: # ei tööta, aga ei koti eriti kah
				if Global.language == "english":
					subtask_cpu_text = "There is a mistake in the solution. Make sure to \n divide the correct number at the start of each row!"
				elif Global.language == "skibidi":
					subtask_cpu_text = "Aww too bad!"
				else:
					subtask_cpu_text = "Lahenduses on viga. Vaata üle,\net ikka õiget arvu jagama hakkad!"
				
				$task_text_box/VBoxContainer/Control/subtask_label.text = subtask_cpu_text
				$task_text_box/VBoxContainer/subtask_label_ph.text = subtask_cpu_text
				
			if Global.subtask == -4:
				if Global.language == "english":
					subtask_cpu_text = "The remainders are incorrect.\nRemember that the remainder must be either 1 or 0."
				elif Global.language == "skibidi":
					subtask_cpu_text = "The remainders are incorrect.\nGet help!"
				else:
					subtask_cpu_text = "Lahenduse tulemusel arvutatavad jäägid on valed.\nPea meeles, et jääk peab tulema kas 1 või 0."
				
				$task_text_box/VBoxContainer/Control/subtask_label.text = subtask_cpu_text
				$task_text_box/VBoxContainer/subtask_label_ph.text = subtask_cpu_text
				
			if Global.subtask == -5:
				if Global.language == "english":
					subtask_cpu_text = "The answer you entered is incorrect. Remember to\nread the answers from the bottom to top!"
				elif Global.language == "skibidi":
					subtask_cpu_text = "Bro. The answer you entered is incorrect!"
				else:
					subtask_cpu_text = "Sisestatud vastus on vale. Pea meeles,\net vastust loetakse alt ülesse!"
				
				$task_text_box/VBoxContainer/Control/subtask_label.text = subtask_cpu_text
				$task_text_box/VBoxContainer/subtask_label_ph.text = subtask_cpu_text
				
			
			
			if Global.world_name == "CPU" and Global._task_binary != null:
				Global._task_binary.set_wrong_explain(subtask_cpu_text)
	else:
		self.visible = false

func set_done_text(done_type, done_text, last_task = false):
	$task_text_box/task_done_container/task_heading.text = done_type
	$task_text_box/task_done_container/Control/subtask_done.text = done_text
	$task_text_box/task_done_container/subtask_label_ph.text = done_text
	if last_task == true:
		$AnimationPlayer.play("last_task_done")
	else:
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("task_done")
	await $AnimationPlayer.animation_finished
	if last_task == true:
		Global.task_ongoing = ""
		print("mina")
	return



func next_subtask(subtask_num = Global.subtask + 1):
	Global.subtask = subtask_num
