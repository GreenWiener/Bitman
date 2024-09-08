extends Control

@onready var play_btn = $CanvasLayer/Buttons/PlayButton
@onready var play_options_btn = $CanvasLayer/Buttons/play_options
@onready var continue_btn = $CanvasLayer/Buttons/play_options/Continue
@onready var start_btn = $CanvasLayer/Buttons/play_options/Start
@onready var settings_btn = $CanvasLayer/Buttons/Settings
@onready var info_btn = $CanvasLayer/Buttons/InfoButton


func _ready():
	play_btn.show()
	play_options_btn.hide()
	
	$AnimationPlayer2.play("startmenu_glitches")
	
	Global.player_in_menu = false
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()


func lang_english():
	play_btn.text = "Play"
	continue_btn.text = "Continue"
	start_btn.text = "Restart"
	settings_btn.text = "Settings"
	info_btn.text = "More info"
	$Label.text = '“There are 10 kinds of people in the world: those who understand binary numerals, and those who don\'t.”\nIan Stewart'
	$Label.position.x = 21

func lang_skibidi():
	play_btn.text = "Skibidi"
	continue_btn.text = "yes"
	start_btn.text = "dop"
	settings_btn.text = "asdolqiuwer"
	info_btn.text = "💩"
	$Label.text = '“There are 💩 kinds of people in the world: those who 💩, and those who don\'t.”\nSomebody'


func _on_play_button_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	if not FileAccess.file_exists("user://savegame.save"):
		start_the_game()
	else:
		play_btn.hide()
		play_options_btn.show()
		
		$AnimationPlayer.play("option_btns_IN")



func _on_info_button_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	StageManager.changeScene("res://menu/info_menu.tscn")



func _on_settings_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	StageManager.changeScene("res://menu/settings_menu.tscn")


func start_the_game():
	Global.start_game()
	if Global.most_recent_scene != null:
		StageManager.changeScene(Global.most_recent_scene)
	else:
		StageManager.changeScene("res://world/world.tscn")


func _on_continue_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	start_the_game()


func _on_start_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	SaveGame.delete_save()
	Global.start_game()
	StageManager.changeScene("res://world/world.tscn")


