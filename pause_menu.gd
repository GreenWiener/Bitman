extends Control

var in_pausemenu = false

func _ready():
	Global._pause_menu = self
	$MusicSlider.value = AudioPlayer.music_volume

func _process(_delta):
	if Input.is_action_just_released("Pause"): # klahvi TAB vahjutamisel
		Global.player_in_menu = true # mängijal on menüü avatud
		in_pausemenu = true
		self.show() # menüü näitamine
	if Input.is_action_just_released("Close") and in_pausemenu == true: # klahvi ESC vahjutamisel
		Global.player_in_menu = false # mängijal pole menüü avatud
		in_pausemenu = false
		self.hide() # menüü peitmine


func show_pause_menu(): # pausi nupu vajutamisel
	Global.player_in_menu = true # mängijal on menüü avatud
	self.show() # menüü näitamine

func _on_continue_pressed(): # "Jätka" nupu vajutamisel
	Global.player_in_menu = false # mängijal pole menüü avatud
	self.hide() # menüü peitmine

func _on_exit_pressed(): # "Salvesta ja sulge" nupu vajutamisel
	SaveGame.save_game() # salvesta mäng
	get_tree().quit() # sulge mäng

func _on_h_slider_value_changed(value): # muusika helitugevuse slideri liigutamisel
	AudioPlayer.set_music_volume(value) # helitugevus = liuguri väärtus

