
extends Node2D

@export_file var panel_scene = ""
@export var panel_name = ""
#@onready var panel_instance = load(panel_scene).instantiate() ##

var reload_queued = false
var helparrow_added = false

#var interact_scene = load("res://menu/InteractText.tscn")
#var player_scene = load("res://player/player.tscn")

#var cpu_menu_instance = load("res://menu/cpu_menu.tscn").instantiate()
#var decimal_task_menu_instance = load("res://menu/task_demical.tscn").instantiate()
#var binary_task_menu_instance = load("res://menu/task_binary.tscn").instantiate()
#var ram_menu_instance = load("res://menu/ram_menu.tscn").instantiate()
var player
var in_interact_area = false

var panel_instance
var close_panel = false

var interaction_label

func _ready():
	Global._controlpanel = self
	#reload_gui()
	#var panel_instance = load(panel_scene).instantiate()
	panel_instance = load(panel_scene).instantiate()
	
	if "Android" in OS.get_name():
		interaction_label = $interaction_label_android
	else:
		interaction_label = $interaction_label

	
	$HelpArrow.hide()
	computer_helparrow()
	
	if Global.language == "english" or Global.language == "skibidi":
		$interaction_label.text = "[E] open"
		$interaction_label_android.text = "[E] open"

func computer_helparrow():
	if panel_name not in Global.showed_helparrow:
		var panel_split = panel_name.split()
		var panel_world = panel_split[0] + panel_split[1] + panel_split[2]
		if panel_world.to_upper() in Global.task_ongoing:
			$HelpArrow.show()

func _physics_process(_delta): 
	#print(Global.player_in_menu)
	#print(Global.player_in_menu)
	if Input.is_action_pressed("Interact_e"): # E interaction
		interaction_label.modulate = "00ff47" # green
	else:
		interaction_label.modulate = "ffffff" #white
		
	#if Global.player_in_menu == true:
	if in_interact_area == true && Input.is_action_just_released("Interact_e") and Global.player_in_menu == false:
		print("💻 <controlpanel> Open panel: ", panel_instance)
		Global.player_in_menu = true
		if panel_name not in Global.showed_helparrow and $HelpArrow.visible == true:
			Global.showed_helparrow.append(panel_name)
			$HelpArrow.hide()
		
		if panel_instance == null:
			panel_instance = load(panel_scene).instantiate()
		Global._player.get_node("CanvasLayer").add_child(panel_instance)
		panel_instance.boot_up()
		
		if panel_scene == "res://menu/ram_menu.tscn":
			panel_instance.reload_files()
		elif panel_scene == "res://menu/cpu_menu.tscn":
			panel_instance.reload_info()
		
		
		if panel_scene == "res://menu/task_demical.tscn" and Global.helparrow_state == "ssd_menu" and helparrow_added == false:
			Global.add_HelpArrow(panel_instance, panel_instance.get_node("example_btn").position - Vector2(6,-8), 1)
			helparrow_added = true
	
	elif Input.is_action_just_released("Close") or close_panel == true:
		# cpu task completion
		if Global._task_binary != null and Global._task_binary.task_binary_completed == true:
			Global.task_ongoing_block.complete_cpu_task()
			Global._task_binary.task_binary_completed = false
			print("complete now!")
		
		close_panel = false
		print("💻 <controlpanel> Close panel: ", panel_instance)
		AudioPlayer.play_fx("res://audio/menu_close.wav")
		Global.player_in_menu = false
		Global._player.get_node("CanvasLayer").remove_child(panel_instance) #player
		if reload_queued == true:
			reload_queued = false
			reload_gui()
			

	

	if self.scale.x < 0:
		interaction_label.scale.x = -0.17
	else:
		interaction_label.scale.x = 0.17


func _on_area_2d_body_entered(body):
	if body is Player:
		#player = body
		in_interact_area = true
		print(in_interact_area)
	
	$HelpArrow.position.y = -11
	interaction_label.show()

func _on_area_2d_body_exited(body):
	if body is Player:
		in_interact_area = false	
		print(in_interact_area)
	
	$HelpArrow.position.y = -7
	interaction_label.hide()






func reload_gui(): # # # ??????
	panel_instance.queue_free()
	panel_instance = load(panel_scene).instantiate()
	print("💻 <controlpanel> reloading GUI")
