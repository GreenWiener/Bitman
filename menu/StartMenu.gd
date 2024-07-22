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

func lang_skibidi():
	play_btn.text = "Skibidi"
	continue_btn.text = "yes"
	start_btn.text = "dop"
	settings_btn.text = "asdolqiuwer"
	info_btn.text = "💩"


func _on_play_button_pressed():
	if not FileAccess.file_exists("user://savegame.save"):
		start_the_game()
	else:
		play_btn.hide()
		play_options_btn.show()
		
		$AnimationPlayer.play("option_btns_IN")



func _on_info_button_pressed():
	StageManager.changeScene("res://menu/info_menu.tscn")



func _on_settings_pressed():
	StageManager.changeScene("res://menu/settings_menu.tscn")


func start_the_game():
	Global.start_game()
	if Global.most_recent_scene != null:
		StageManager.changeScene(Global.most_recent_scene)
	else:
		StageManager.changeScene("res://world/world.tscn")


func _on_continue_pressed():
	start_the_game()


func _on_start_pressed():
	SaveGame.delete_save()
	Global.start_game()
	StageManager.changeScene("res://world/world.tscn")


