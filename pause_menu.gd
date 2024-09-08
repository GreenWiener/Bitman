extends Control

var in_pausemenu = false

func _ready():
	Global._pause_menu = self
	$CanvasLayer.hide()
	$CanvasLayer/Buttons/MusicSlider.value = Global.music_volume
	$CanvasLayer/Buttons/FxSlider.value = Global.fx_volume
	
	
	if "Android" in OS.get_name():
		$TouchScreenButton.visible = true
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()

func lang_english():
	$CanvasLayer/Buttons/middle/Continue.text = "Continue"
	$CanvasLayer/Buttons/middle/Achievements.text = "Achievements"
	$CanvasLayer/Buttons/middle/Startmenu.text = "Start menu"
	$CanvasLayer/Buttons/middle/Exit.text = "Save and quit"
	$CanvasLayer/Buttons/Label.text = "music"
	$CanvasLayer/Buttons/Label2.text = "sound effects"

func lang_skibidi():
	$CanvasLayer/Buttons/middle/Continue.text = "DONT STOP"
	$CanvasLayer/Buttons/middle/Achievements.text = "meanings of life"
	$CanvasLayer/Buttons/middle/Startmenu.text = "jump to the 💩 in 🚽"
	$CanvasLayer/Buttons/middle/Exit.text = "Skedaddle"
	$CanvasLayer/Buttons/Label.text = "music"
	$CanvasLayer/Buttons/Label2.text = "💩 effects"

func _process(_delta):
	if Input.is_action_just_released("Close") and Global.player_in_menu == false and Global._player.welcome_text_close == false: # klahvi ESC vahjutamisel  #Input.is_action_just_released("Pause")
		show_pause_menu()
	elif Input.is_action_just_released("Close") and in_pausemenu == true: # klahvi ESC vahjutamisel
		hide_pause_menu()

func _on_continue_pressed(): # "Jätka" nupu vajutamisel
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	hide_pause_menu()

func show_pause_menu(): # pausi nupu vajutamisel
	#get_tree().paused = true
	$CanvasLayer/Buttons.visible = true
	$CanvasLayer/Achievements_tab.visible = false
	Global.player_in_menu = true # mängijal on menüü avatud
	in_pausemenu = true
	Global._pause_menu.get_node("CanvasLayer").show()
	Global._pause_menu.show() # menüü näitamine
	
	
	# saavutuste arv
	$CanvasLayer/Achievements_tab/VBoxContainer/Panel_topbar/HBoxContainer/count.text = "(" + str(len(Global.earned_achievments)) + "/" + str($CanvasLayer/Achievements_tab/VBoxContainer/PanelContainer/ScrollContainer/list_of_achievements.get_child_count()) + ")"
	
	if "%count%" in $CanvasLayer/Achievements_tab/VBoxContainer/Panel_midbar/Label.text:
		$CanvasLayer/Achievements_tab/VBoxContainer/Panel_midbar/Label.text = $CanvasLayer/Achievements_tab/VBoxContainer/Panel_midbar/Label.text.replace("%count%", str($CanvasLayer/Achievements_tab/VBoxContainer/PanelContainer/ScrollContainer/list_of_achievements.get_child_count()))
	
	for el in $CanvasLayer/Achievements_tab/VBoxContainer/PanelContainer/ScrollContainer/list_of_achievements.get_children():
		if el.name in Global.earned_achievments:
			el.add_theme_stylebox_override("panel", load("res://menu/achievement_block_bg2.tres"))
			#el.remove_theme_stylebox_override("panel")

func hide_pause_menu():
	#get_tree().paused = false
	Global.player_in_menu = false # mängijal pole menüü avatud
	in_pausemenu = false
	$CanvasLayer.hide()
	self.hide() # menüü peitmine



func _on_exit_pressed(): # "Salvesta ja sulge" nupu vajutamisel
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	SaveGame.save_game() # salvesta mäng
	get_tree().quit() # sulge mäng

func _on_startmenu_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	SaveGame.save_game()
	StageManager.changeScene("res://start_menu.tscn")


func _on_music_slider_value_changed(value): # muusika helitugevuse slideri liigutamisel
	AudioPlayer.set_music_volume(value) # helitugevus = liuguri väärtus


func _on_fx_slider_value_changed(value):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		AudioPlayer.play_fx("res://audio/btn_click_short.wav")
	AudioPlayer.set_fx_volume(value)


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


func _on_achievements_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	$CanvasLayer/Buttons.visible = false
	$CanvasLayer/Achievements_tab.visible = true


func _on_back_button_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	$CanvasLayer/Buttons.visible = true
	$CanvasLayer/Achievements_tab.visible = false



