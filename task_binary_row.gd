extends HBoxContainer

@export var first_row : bool

func _ready():
	Global.task_binary_rows.append(self)
	for el in Global.task_binary_rows:
		if el == null:
			Global.task_binary_rows.erase(el)
	
	if first_row == true:
		$input1.text = str(Global.task_dec_num)
		$input1.editable = false
		calc_first_answer(str(Global.task_dec_num))
	
	if Global.language == "english" or Global.language == "skibidi":
		$input2.placeholder_text = "whole(y)"
		$answer3.placeholder_text = "remainder"
		$answer3.custom_minimum_size.x = 95

func remove_row_from_list():
	Global.task_binary_rows.remove_at(len(Global.task_binary_rows)-1)



func hide_arrow():
	$TaskArrow.hide()

var row_1st_num
func _on_input_1_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick.wav")
	if self.name == "task_binary_row": # esimese rea puhul
		Global.task_binary_num = new_text # defineeri algne kümnendarv, mida hakatakse kahendarvuks teisendama
	calc_first_answer(new_text)
func calc_first_answer(new_text):
	row_1st_num = int(new_text)
	var answer1 = float(new_text) / 2
	$answer1.text = str(answer1)

func _on_input_2_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick.wav")
	var answer2 = float(new_text) * 2
	$answer2.text = str(answer2)


var subtrac1
var subtrac2
var answer3
var row_answer

func _on_input_3_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick.wav")
	subtrac1 = new_text
	calc_input_3_and_4()

func _on_input_4_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick.wav")
	subtrac2 = new_text
	calc_input_3_and_4()

func calc_input_3_and_4():
	if subtrac1 != null and subtrac2 != null:
		answer3 = float(subtrac1) - float(subtrac2)
		$answer3.text = str(answer3)
		row_answer = str(answer3)


func get_row_answer():
	return row_answer

func get_row_1st_num():
	return row_1st_num


# android keyboard
func _on_input_1_focus_entered():
	if first_row != true and DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_input_1_focus_exited():
	DisplayServer.virtual_keyboard_hide()


func _on_input_2_focus_entered():
	if DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_input_2_focus_exited():
	DisplayServer.virtual_keyboard_hide()


func _on_input_3_focus_entered():
	if DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_input_3_focus_exited():
	DisplayServer.virtual_keyboard_hide()


func _on_input_4_focus_entered():
	DisplayServer.virtual_keyboard_show('')

func _on_input_4_focus_exited():
	DisplayServer.virtual_keyboard_hide()
