extends Control

var in_pausemenu = false

func _ready():
	Global._pause_menu = self
	$CanvasLayer.hide()
	$CanvasLayer/Buttons/MusicSlider.value = Global.music_volume
	
	if "Android" in OS.get_name():
		$TouchScreenButton.visible = true
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()

func lang_english():
	$CanvasLayer/Buttons/Continue.text = "Continue"
	$CanvasLayer/Buttons/Startmenu.text = "Start menu"
	$CanvasLayer/Buttons/Exit.text = "Save and quit"
	$CanvasLayer/Buttons/Label.text = "music"

func lang_skibidi():
	$CanvasLayer/Buttons/Continue.text = "DONT STOP"
	$CanvasLayer/Buttons/Startmenu.text = "jump to the 💩 in 🚽"
	$CanvasLayer/Buttons/Exit.text = "Skedaddle"
	$CanvasLayer/Buttons/Label.text = "music"

func _process(_delta):
	if Input.is_action_just_released("Pause"): # klahvi TAB vahjutamisel
		show_pause_menu()
	if Input.is_action_just_released("Close") and in_pausemenu == true: # klahvi ESC vahjutamisel
		hide_pause_menu()

func _on_continue_pressed(): # "Jätka" nupu vajutamisel
	hide_pause_menu()

func show_pause_menu(): # pausi nupu vajutamisel
	Global.player_in_menu = true # mängijal on menüü avatud
	in_pausemenu = true
	$CanvasLayer.show()
	self.show() # menüü näitamine

func hide_pause_menu():
	Global.player_in_menu = false # mängijal pole menüü avatud
	in_pausemenu = false
	$CanvasLayer.hide()
	self.hide() # menüü peitmine



func _on_exit_pressed(): # "Salvesta ja sulge" nupu vajutamisel
	SaveGame.save_game() # salvesta mäng
	get_tree().quit() # sulge mäng

func _on_startmenu_pressed():
	SaveGame.save_game()
	StageManager.changeScene("res://start_menu.tscn")


func _on_h_slider_value_changed(value): # muusika helitugevuse slideri liigutamisel
	AudioPlayer.set_music_volume(value) # helitugevus = liuguri väärtus



func _on_touch_screen_button_released():
	Global.player_in_menu = false
	self.hide()
	Global._player.get_node("CanvasLayer/Console").show()
	Global._player.get_node("CanvasLayer/Console").grab_focus()


# värvi efekt ekraanil
func _on_continue_button_down():
	$PointLight2D.color = "e90080"
func _on_continue_button_up():
	$PointLight2D.color = "215dff77"
func _on_exit_button_down():
	$PointLight2D.color = "e90080"
func _on_exit_button_up():
	$PointLight2D.color = "215dff77"
