
extends Node2D

@export_file var panel_scene = ""
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
func _ready():
	Global._controlpanel = self
	print("panel_scene: ", panel_scene)
	#reload_gui()
	#var panel_instance = load(panel_scene).instantiate()
	panel_instance = load(panel_scene).instantiate()

func _physics_process(_delta): # E interaction
	#print(Global.player_in_menu)
	#print(Global.player_in_menu)
	if Global.player_in_menu == true:
		if Input.is_action_just_released("Interact_e") or Input.is_action_just_released("Close"):
			print("close panel: ", panel_instance)
			Global.player_in_menu = false
			Global._player.get_node("CanvasLayer").remove_child(panel_instance) #player
			if reload_queued == true:
				reload_queued = false
				reload_gui()
			

	elif in_interact_area == true && Input.is_action_just_released("Interact_e"):
		print("open panel: ", panel_instance)
		Global.player_in_menu = true
		
		Global._player.get_node("CanvasLayer").add_child(panel_instance)
		
		if panel_scene == "res://menu/ram_menu.tscn":
			panel_instance.reload_files()
		
		
		if panel_scene == "res://menu/task_demical.tscn" and Global.helparrow_state == "ssd_menu" and helparrow_added == false:
			Global.add_HelpArrow(panel_instance, panel_instance.get_node("example_btn").position - Vector2(9,-8))
			helparrow_added = true

	if self.scale.x < 0:
		$pickup_label.scale.x = -0.12
	else:
		$pickup_label.scale.x = 0.12		


func _on_area_2d_body_entered(body):
	if body is Player:
		#player = body
		in_interact_area = true
		print(in_interact_area)
		
	$pickup_label.show()

func _on_area_2d_body_exited(body):
	if body is Player:
		in_interact_area = false	
		print(in_interact_area)
	
	$pickup_label.hide()






func reload_gui(): # # # ??????
	panel_instance.queue_free()
	panel_instance = load(panel_scene).instantiate()
	print("> reloading task gui")
