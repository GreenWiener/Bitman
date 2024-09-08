extends PanelContainer

@export var number : int
@export var symbol : String


func _ready():
	$num_sym/num.text = str(number)
	$num_sym/sym.text = symbol


func _process(delta):
	pass


func _on_button_pressed():
	AudioPlayer.play_fx("res://audio/tick.wav")
	$"../../../..".write_sym(symbol)
