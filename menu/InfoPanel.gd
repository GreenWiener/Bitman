#@tool
#class_name Instance

extends Area2D

#var player = preload("res://player/player.tscn")
#@onready var interact_scene = load("res://world/TextInfo.tscn")

###text
#CPU (central processing unit) ehk arvuti protsessor on kiip, mis töötab arvuti ajuna. Protsessor täidab käske, mida käivitatud programmid talle annavad.
#RAM (random access memory) ehk arvuti muutmälu on kiip, mis töötab arvuti lühiajalise mäluna. Sellel kiibil on programmid ja andmed, kuni sa arvuti välja lülitad.
#GPU (graphics processing unit) ehk videokaart on arvuti laiendusplaat, mis ühendatakse emaplaadiga ning võimaldab arvutil kuvada ekraanile teksti ja pilte. Võimsad videokaardid kiirendavad Windowsi programmide ja 3D-graafika kuva.

#@export var interaction_type = ""
#@export var menu = ""

@export var text = ""
@export var text_en = ""
@export var panel_name = ""
@export_file var sprite = ""
@export var interaction_key = true
@export var is_enabled = true



var interact_instance = load("res://menu/text_dialog.tscn").instantiate()
var interaction_label

var player

var player_in_menu = false
var in_interact_area = false

func _ready():
	Global._info_panel.append(self)
	
	if "Android" in OS.get_name():
		interaction_label = $interaction_label_android
	else:
		interaction_label = $interaction_label
	if sprite == "":
		$Sprite2D.texture = load("res://world/gray_sign.png")
	elif sprite == "none":
		$Sprite2D.hide()
	else:
		$Sprite2D.texture = load(sprite)
	
	if Global.language == "english" or Global.language == "skibidi":
		text = text_en
		$interaction_label.text = "[E] read"
		$interaction_label_android.text = "read"
		
	if self.scale.x == -1:
		interaction_label.scale.x = -0.12
	
	# helparrow
	$HelpArrow.hide()
	show_helparrow()


func show_helparrow():
	if panel_name not in Global.showed_helparrow and panel_name != "" and panel_name != "cpu_sb_infopanel2" and interaction_key == true:
		var panel_split = panel_name.split()
		var panel_world = panel_split[0] + panel_split[1] + panel_split[2]
		if panel_world.to_upper() in Global.task_ongoing:
			$HelpArrow.show()
		elif panel_name == "start_statue":
			$HelpArrow.show()


func _physics_process(_delta): # E interaction
	if Input.is_action_pressed("Interact_e"):
		interaction_label.modulate = "00ff47" # green
	else:
		interaction_label.modulate = "ffffff" # white
	
	if player_in_menu == true and Input.is_action_just_released("Interact_e"):
		close_panel()

	elif player_in_menu == false and in_interact_area == true and Input.is_action_just_released("Interact_e"):
		open_panel()


func open_panel(panel_text = text):
	AudioPlayer.play_fx("res://audio/menu_open.wav")
	print("open dialog.")
	if panel_name not in Global.showed_helparrow:
		Global.showed_helparrow.append(panel_name)
	$HelpArrow.hide()
		
	player_in_menu = true
	player.get_node("CanvasLayer").add_child(interact_instance)
	interact_instance.get_child(1).text = panel_text

func close_panel():
	if player_in_menu == true:
		AudioPlayer.play_fx("res://audio/menu_close.wav")
		print("close dialog.")
		player_in_menu = false
		player.get_node("CanvasLayer").remove_child(interact_instance)
		
		if panel_name == "start_statue" and "task1" not in Global.showed_helparrow:
			Global._player.get_node("CanvasLayer/Buttons/SideButtons/task_btn/HelpArrow").visible = true
	
	if Global.rongirajatroll == false and (panel_name == "rongirada3" or panel_name == "rongirada4"):
		is_enabled = false


func _on_body_entered(body):
	if body is Player:
		player = body
		in_interact_area = true
		if interaction_key == true:
			$HelpArrow.position.y = -9
			interaction_label.show()
		else:
			if is_enabled == true:
				open_panel(text)
	
	if panel_name == "rongirada2":
		Global.rongirajatroll = true
	if panel_name == "rongirada1" or panel_name == "rongirada4":
		Global.rongirajatroll = false


func _on_body_exited(body):
	if body is Player:
		in_interact_area = false
		#player_in_menu = false
		#body.get_node("CanvasLayer").remove_child(interact_instance)
		if is_enabled == true:
			close_panel()
		$HelpArrow.position.y = -6
		interaction_label.hide()



#func _on_button_pressed():
	#if in_interact_area == false:
		#Global.PopUpCursor("Liiga kaugel!")
	#else:
		#Global.PopUpCursor("Vajuta E klahvi")
