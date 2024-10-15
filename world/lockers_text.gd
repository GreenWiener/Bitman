extends Control

var color_error = "f08080" # punane
var color_file = "8080f0" # sinine

var scrolling = false



var delta_value = 0
func _process(delta):
	delta_value = delta
	
	if scrolling == false:
		$lockers_text/Label.position.x = 0
	scrolling = false

func scroll_anim():
	scrolling = true
	$lockers_text/Label.position.x += -40 * delta_value
	if $lockers_text/Label.position.x < -300:
		$lockers_text/Label.position.x = 0


func set_text(set_the_text, set_the_colour):
	print("setting locker_label text: ", set_the_text, ", ", set_the_colour)
	$lockers_text/Label.text = set_the_text + "        " + set_the_text + "        " + set_the_text + "        " + set_the_text
	$lockers_text/Label.modulate = set_the_colour
