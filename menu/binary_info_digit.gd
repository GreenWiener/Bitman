extends PanelContainer


@export var digit : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$binary_info_digit/Label.text = str(digit)
	
	#if Input.is_action_just_pressed("mb_left") and mouse_inarea == true:
		#$select_color.visible = !$select_color.visible





#var mouse_inarea = false
#
#func _on_binary_info_digit_mouse_entered():
	#mouse_inarea = true
	#print(self, " MOUSE ENTERED")
	#if Input.is_action_pressed("mb_left"):
		#$select_color.visible = !$select_color.visible
#
#
#func _on_binary_info_digit_mouse_exited():
	#print(self, " MOUSE EXITED")
	#mouse_inarea = false


func _on_button_toggled(toggled_on):
	print(self, "  is  ", toggled_on)
