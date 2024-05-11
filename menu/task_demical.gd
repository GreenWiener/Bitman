extends Control

@onready var demical_row = preload("res://menu/task_demical_row.tscn").instantiate()


func _ready():
	# esimese ploki lisamine
	$ScrollContainer/GridContainer/Add_row/remove_row_btn.hide()
	$ScrollContainer/GridContainer.add_child(demical_row)
	$ScrollContainer/GridContainer.move_child($ScrollContainer/GridContainer/Add_row, $ScrollContainer/GridContainer.get_child_count()) # liiguta nupp viimaseks
	demical_row.hide_pluss()
	

func _process(delta):
	# binaararvu teksti panemine
	if Global.task_bin_num == null:
		$ScrollContainer/GridContainer/num_placeholder/binary_num.text = ""
	else:
		$ScrollContainer/GridContainer/num_placeholder/binary_num.text = str(Global.task_bin_num)
		binary_num = Global.task_bin_num
		binary_num_digits = binary_num.split()


func _on_add_row_btn_pressed():
	$ScrollContainer/GridContainer/Add_row/remove_row_btn.show()
	
	$ScrollContainer/GridContainer.add_child(preload("res://menu/task_demical_row.tscn").instantiate())
	$ScrollContainer/GridContainer.move_child($ScrollContainer/GridContainer/Add_row, $ScrollContainer/GridContainer.get_child_count()) # liiguta nupp viimaseks
	
func _on_remove_row_btn_pressed():
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
				if el.name != "num_placeholder" and el.name != "Add_row":
					print("digit: ", el.get_binary_digit(), " == ", binary_num_digits[indeks])
					if el.get_binary_digit() == binary_num_digits[indeks]:
						correct_digits_count += 1
					print("aste: ", el.get_binary_aste(), " == ", str(len(binary_num_digits)-1-indeks))
					if el.get_binary_aste() == str(len(binary_num_digits)-1-indeks):
						correct_astmed_count += 1
					indeks += 1
		
		# kui on õige
		print(correct_digits_count, " == ", len(binary_num_digits), " and ", correct_astmed_count, " == ", len(binary_num_digits), " and ", $ScrollContainer/GridContainer.get_child_count()-2, " == ", len(binary_num_digits))
		if correct_digits_count == len(binary_num_digits) and correct_astmed_count == len(binary_num_digits) and $ScrollContainer/GridContainer.get_child_count()-2 == len(binary_num_digits):
			print("ÕIGE VASTUS")
			$Control/kontroll.modulate = "00ff00"
			_correct_answer() # arvuta kümnendarvuline vastus'
			Global.bin_task_completed_last = calculated_answer
			Global.bin_tasks_completed.append(calculated_answer)
			
			# kapi koodi itemi andmine kätte
			Global._player.hold_item("kapi_kood1 " + str(calculated_answer))
			calculated_answer = 0
			
		else:
			print("VALE VASTUS")
			$Control/kontroll.modulate = "ff0000"





func _on_example_btn_pressed():
	$Example.show()

func _on_close_example_btn_pressed():
	$Example.hide()	


