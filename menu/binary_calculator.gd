extends Control


func _ready():
	#print(0b10)
	pass



func from2to10(number): # binaararvu teisendamine kümnendarvuks
	var each_number = str(number).split()
	
	var aste = 0
	var astendatud_num
	var kumnendarv = 0
	
	for i in range(len(each_number), 0, -1):
		astendatud_num = int(each_number[i-1]) * (2**aste)
		kumnendarv += astendatud_num
		#print("num: ", i, " aste: ", aste, " 2aste: ", 2**aste, " astendatud: ", astendatud_num)
		aste += 1
	
	$detsimaalarv.text = str(kumnendarv)

func from10to2(number): # kümnendarvu teisendamine binaararvuks
	var jagatav_num = int(number)
	var jagatav_num_uus = int(number)
	var num_jaak
	var binaararv = ""
	
	while jagatav_num_uus > 0:
		jagatav_num = jagatav_num_uus / 2
		num_jaak = jagatav_num_uus % 2 # jäägi arvutamine
		jagatav_num_uus = jagatav_num
		binaararv += str(num_jaak)
		
	$binaararv.text = str(binaararv.reverse())
	



func _on_binaararv_text_submitted(new_text):
	from2to10(new_text)

func _on_detsimaalarv_text_submitted(new_text):
	from10to2(new_text)
