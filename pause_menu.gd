extends Control

var in_pausemenu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global._pause_menu = self
	$HSlider.value = AudioPlayer.music_volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("Pause"):
		Global.player_in_menu = true
		in_pausemenu = true
		self.show()
	if Input.is_action_just_released("Close") and in_pausemenu == true:
		Global.player_in_menu = false
		in_pausemenu = false
		self.hide()


func show_pause_menu():
	Global.player_in_menu = true
	self.show()


func _on_continue_pressed():
	Global.player_in_menu = false
	self.hide()

var save_script = load("res://SaveData.gd")
func _on_exit_pressed():
	SaveGame.save_game()
	get_tree().quit()


func _on_h_slider_value_changed(value):
	AudioPlayer.set_music_volume(value)
