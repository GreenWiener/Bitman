extends Control



func _on_music_slider_value_changed(value):
	AudioPlayer.set_music_volume(value)

func _on_fx_volume_value_changed(value):
	AudioPlayer.set_fx_volume(value)
	AudioPlayer.play_fx("res://audio/btn_click_short.wav")


@onready var musicslider: Slider = get_node("CanvasLayer/Control/Panel/music_volume")
@onready var fxslider: Slider = get_node("CanvasLayer/Control/Panel/fx_volume")
@onready var LanguageMenu = $CanvasLayer/Control/Panel/LanguageMenu
@onready var language_btn = $CanvasLayer/Control/Panel/language_btn
@onready var english_btn = $CanvasLayer/Control/Panel/LanguageMenu/VBoxContainer/english
@onready var eesti_btn = $CanvasLayer/Control/Panel/LanguageMenu/VBoxContainer/eesti

@onready var label_h1 = $CanvasLayer/Control/Panel/H1
@onready var label_h2 = $CanvasLayer/Control/Panel/H2
@onready var label_h3 = $CanvasLayer/Control/Panel/H3


func _ready() -> void:
	
	#$CanvasLayer/Panel/OptionButton._make_custom_tooltip("TEST")
	if Global.music_volume == -100:
		if musicslider != null:
			musicslider.value = -30
			#print("set -30")
	else:
		if musicslider != null:
			musicslider.value = int(Global.music_volume)
			#print("set ", int(Global.music_volume), "  (originally ", Global.music_volume, ")")
	
	if Global.fx_volume == -100:
		if fxslider != null:
			fxslider.value = -30
			#print("set -30")
	else:
		if fxslider != null:
			fxslider.value = int(Global.fx_volume)
	
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()

func lang_english():
	label_h1.text = "Sound effects"
	label_h2.text = "Music"
	label_h3.text = "Language"
	language_btn.text = "english"
	english_btn.text = "english"
	eesti_btn.text = "estonian"

func lang_skibidi():
	label_h1.text = "tsk tsk sszz"
	label_h2.text = "🎵 yes yes 🎶"
	label_h3.text = "Langu 🚽 Age"
	language_btn.text = "skibidi"
	english_btn.text = "🚽🚾"
	eesti_btn.text = "♋"

func _process(delta):
	if Global.language != null and language_btn != null:
		language_btn.text = Global.language


func _make_custom_tooltip(for_text):
	# This exists, and is a Control node, with a panel-container and label inside of it
	var tooltip = preload("res://menu/tooltip.tscn").instantiate()
	tooltip.get_node("Label").text = for_text
	
	return tooltip


func _on_language_btn_pressed():
	AudioPlayer.play_fx("res://audio/btn_click_2.wav")
	LanguageMenu.visible = !LanguageMenu.visible


func _on_eesti_pressed():
	AudioPlayer.play_fx("res://audio/menu_click1.wav")
	LanguageMenu.visible = false
	language_btn.button_pressed = false
	Global.language = "eesti"
	get_tree().reload_current_scene()

func _on_english_pressed():
	AudioPlayer.play_fx("res://audio/menu_click1.wav")
	LanguageMenu.visible = false
	language_btn.button_pressed = false
	Global.language = "english"
	get_tree().reload_current_scene()

func _on_skibidi_pressed():
	AudioPlayer.play_fx("res://audio/menu_click1.wav")
	LanguageMenu.visible = false
	language_btn.button_pressed = false
	Global.language = "skibidi"
	get_tree().reload_current_scene()






