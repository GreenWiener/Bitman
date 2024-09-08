extends HBoxContainer


var binary_digit
var aste

func _on_binary_num_digit_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick2.wav")
	var new_text_one = new_text.split()[0]
	#$binary_num_digit.text = new_text_one
	#var muutuja = len($binary_num_digit.text.split())
	if len($binary_num_digit.text.split()) > 1:
		for i in range(1, len($binary_num_digit.text.split())):
			$binary_num_digit.text.split().remove_at(i)
			$binary_num_digit.text = $binary_num_digit.text[0]
			
	binary_digit = new_text_one

func _on_binary_num_aste_text_changed(new_text):
	AudioPlayer.play_fx("res://audio/tick.wav")
	aste = new_text
	print("get_binary_aste: ", aste)

func get_binary_digit():
	return binary_digit
	
func get_binary_aste():
	return aste


func hide_pluss():
	#$"Label+".hide()
	$"Label+".text = " "


# android keyboard
func _on_binary_num_digit_focus_entered():
	if DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_binary_num_digit_focus_exited():
	DisplayServer.virtual_keyboard_hide()


func _on_binary_num_aste_focus_entered():
	if DisplayServer.virtual_keyboard_get_height() == 0:
		DisplayServer.virtual_keyboard_show('')

func _on_binary_num_aste_focus_exited():
	DisplayServer.virtual_keyboard_hide()
