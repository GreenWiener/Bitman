extends AudioStreamPlayer2D


const theme_music = preload("res://audio/Project_game.wav")
const train_music = preload("res://audio/Project_game_train.wav")


func _play_music(music: AudioStream, volume = Global.music_volume):
	#if stream == music:
	#	return
	
	stream = music
	volume_db = volume
	play()


func play_music_level():
	_play_music(theme_music)

func play_music_train():
	_play_music(train_music)

func set_music_volume(volume):
	Global.music_volume = volume
	volume_db = Global.music_volume
	if volume == -30:
		volume_db = -100
		Global.music_volume = -100

func set_fx_volume(volume2):
	Global.fx_volume = volume2
	$audio_player2.volume_db = Global.fx_volume
	if volume2 == -30:
		$audio_player2.volume_db = -100
		Global.fx_volume = -100
		if Global._player != null:
			Global._player.get_node("AudioStreamPlayer2D").volume_db = -100
	
	if Global._player != null:
		Global._player.get_node("AudioStreamPlayer2D").volume_db = volume2
	


func _process(_delta):
	volume_db = Global.music_volume
	$audio_player2.volume_db = Global.fx_volume
	if Global._player != null:
		Global._player.get_node("AudioStreamPlayer2D").volume_db = Global.fx_volume

	if playing == false:
		_play_music(theme_music)


func play_fx(fx_file):
	if $audio_player2.stream != load(fx_file):
		$audio_player2.stream = load(fx_file)
	$audio_player2.play()
	

func play_train_noise():
	$audio_player3.stream = load("res://audio/train_noise.wav")
	$audio_player3.play()
	
