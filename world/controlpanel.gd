
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
	
	# helparrow
	$HelpArrow.hide()
	if panel_name not in Global.controlpanel_arrows:
		$HelpArrow.show()

func _physics_process(_delta): # E interaction
	#print(Global.player_in_menu)
	#print(Global.player_in_menu)
	if Input.is_action_pressed("Interact_e"):
		interaction_label.modulate = "00ff47" # green
	else:
		interaction_label.modulate = "ffffff" #white
		
	if Global.player_in_menu == true:
		if Input.is_action_just_released("Interact_e") or Input.is_action_just_released("Close") or close_panel == true:
			close_panel = false
			print("💻 <controlpanel> Close panel: ", panel_instance)
			Global.player_in_menu = false
			Global._player.get_node("CanvasLayer").remove_child(panel_instance) #player
			if reload_queued == true:
				reload_queued = false
				reload_gui()
			

	elif in_interact_area == true && Input.is_action_just_released("Interact_e"):
		print("💻 <controlpanel> Open panel: ", panel_instance)
		Global.player_in_menu = true
		Global.controlpanel_arrows.append(panel_name)
		$HelpArrow.hide()
		
		Global._player.get_node("CanvasLayer").add_child(panel_instance)
		
		if panel_scene == "res://menu/ram_menu.tscn":
			panel_instance.reload_files()
		
		
		if panel_scene == "res://menu/task_demical.tscn" and Global.helparrow_state == "ssd_menu" and helparrow_added == false:
			Global.add_HelpArrow(panel_instance, panel_instance.get_node("example_btn").position - Vector2(6,-8), 1)
			helparrow_added = true

	if self.scale.x < 0:
		interaction_label.scale.x = -0.12
	else:
		interaction_label.scale.x = 0.12		


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
