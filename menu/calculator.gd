extends Control


func _ready():
	for btn in $GridContainer.get_children():
		if btn.name.is_valid_int():
			btn.pressed.connect(Callable(self, "_number_buttons").bind(btn))
	
	var a_number = 1100
	from2to10(a_number)

func from2to10(number):
	var each_number = str(number).split()
	
	var aste = 0
	var astendatud_num
	var kumnendarv = 0
	
	for i in range(len(each_number), 0, -1):
		astendatud_num = int(each_number[i-1]) * (2**aste)
		kumnendarv += astendatud_num
		#print("num: ", i, " aste: ", aste, " 2aste: ", 2**aste, " astendatud: ", astendatud_num)
		aste += 1
	
	#print(kumnendarv)
	
	
	
	
	

func _number_buttons(btn):
	$LineEdit.text += btn.name


func _process(delta):
	pass








#func _on_num_1_pressed():
	#$LineEdit.text += "1"
#
#
#func _on_num_2_pressed():
	#$LineEdit.text += "2"
#
#
#func _on_num_3_pressed():
	#$LineEdit.text += "3"
#
#
#func _on_num_4_pressed():
	#$LineEdit.text += "4"
#
#
#func _on_num_5_pressed():
	#$LineEdit.text += "5"
#
#
#func _on_num_6_pressed():
	#$LineEdit.text += "6"
#
#
#func _on_num_7_pressed():
	#$LineEdit.text += "7"
#
#
#func _on_num_8_pressed():
	#$LineEdit.text += "8"
#
#
#func _on_num_9_pressed():
	#$LineEdit.text += "9"
#
#
#func _on_num_0_pressed():
	#$LineEdit.text += "0"
#
#func _on_koma_pressed():
	#$LineEdit.text += ","
#
#
#func _on_jagamine_pressed():
	#$LineEdit.text += "÷"
#
#
#func _on_korrutamine_pressed():
	#$LineEdit.text += "×"
#
#
#func _on_lahutamine_pressed():
	#$LineEdit.text += "-"
#
#
#func _on_liitmine_pressed():
	#$LineEdit.text += "+"
#
#
#func _on_vastus_pressed():
	#vastus()
#
#func vastus():
	#print($LineEdit.text.split())


