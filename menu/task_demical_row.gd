extends HBoxContainer


var binary_digit
var aste

func _on_binary_num_digit_text_changed(new_text):
	binary_digit = new_text

func _on_binary_num_aste_text_changed(new_text):
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
