extends AudioStreamPlayer2D


const theme_music = preload("res://audio/Project_game.wav")
const train_music = preload("res://audio/Project_game_train.wav")

var music_volume = 0.0

func _play_music(music: AudioStream, volume = music_volume):
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
	music_volume = volume
	volume_db = music_volume
	if volume == -30:
		volume_db = -100
		music_volume = -100


func _process(_delta):
	if playing == false:
		_play_music(theme_music)
