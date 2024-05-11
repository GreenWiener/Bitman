## ATTATCH SCRIPT TO PLAYER2 FOR TESTING
#
extends CharacterBody2D
##class_name Player
#
#@onready var hand1_rotation = $"skeleton/player-arm1"
#@onready var hand2_rotation = $"skeleton/player-arm2"
#var hand1_rotation_switch = false
#var hand2_rotation_switch = true
#@onready var leg1_pos = $"skeleton/player-leg1"
#@onready var leg2_pos = $"skeleton/player-leg2"
#var leg1_pos_switch = true
#var leg2_pos_switch = false
#
#var in_interact_area = false
#var console_focus = false
#
#func _ready() -> void: ## funktsioon, mis käivitub, stseen on ära laadinud
	#self.global_position = Global.player_inital_map_position # mängija asukoht stseeni alguses
	#Global._player = self # Global skriptis muutuja _player määramine mängijaks
	#
	##var infotextnode = $text
	#refresh_item("box1") # kontrollib mängija käes olevate asju
#
#var VELOCITY = Vector2.ZERO	
#
##@export var float_number: float = 5
#
## ----------------------------------------------------------------------------------------
#
#@export var MAX_SPEED = 40
#const ACCELERATION = 300
#const FRICTION = 300
#
#func _physics_process(delta): ## mängija omadused ja füüsika, jookseb kogu aeg, kui stseen on laetud
	#Global.player_position = position # mängija asukoht Global skriptis kasutamiseks
	#
	## liikumise klahvid ja loogika
	#var input_vector = Vector2.ZERO
	#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#input_vector = input_vector.normalized()
	#
	#set_velocity(VELOCITY)
	#move_and_slide()
	#
	#if input_vector.x == 0 and input_vector.y == 0: # kui liikumiskiirus on 0
		#idle_Anim() # ei liigu
		#VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)
	#else:
		#VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#
#
## ----------------------------------------------------------------------------------------
#
		## kehaosade liikumise animatsioonid
		#if input_vector.x > 0:  # paremale liikumisel x-teljel
			#$skeleton.scale.x = 1 # tegelase suurus on 1, ehk ta vaatab paremale
			#walking_HandsAnim() # käte liigutamise funktioon
			#walking_LegsAnim() # jalgade liigutamise funktioon
			#
		#elif input_vector.x < 0:  # vasakule liikumisel x-teljel
			#$skeleton.scale.x = -1 # tegelase suurus on -1, ehk ta vaatab vasakule
			#walking_HandsAnim()
			#walking_LegsAnim()
		#
		#if input_vector.y > 30 or input_vector.y < 30:  # liikumisel y-teljel
			#walking_HandsAnim()
			#walking_LegsAnim()
#
#
#
##func apply_acceleration(amount):
##	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
##	#VELOCITY = VELOCITY.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#
##func apply_friction():
##	velocity.x = move_toward(velocity.x, 0, FRICTION)
##	#VELOCITY = VELOCITY.move_toward(Vector2.ZERO, FRICTION * delta)
#
#
##var player_holding_item
#var item_sprite = Sprite2D.new()
#
##@onready var gloabb = load("res://Global.gd")
#var item = load("res://world/item.gd")
#
#func hold_item(item_name): ## eseme käes hoidmine
	#print("<PLAYER>: '",item_name,"' käes hoidmine")
	#Global.player_holding_item = true
	#self.get_node("skeleton/player-arm2").add_child(item_sprite)
	##item_sprite.set_texture(load("res://world/" + item_name + ".png"))
	#item_sprite.texture = load("res://world/" + item_name + ".png")
	#Global.despawn_item(item_name)
#
#func release_item(item_name): ## eseme eemaldamine käest
	#print("<PLAYER>: '",item_name,"' eemaldamine käest")
	#Global.player_holding_item = false
	#self.get_node("skeleton/player-arm2").remove_child(item_sprite)
	#Global.spawn_item(item_name, position)
#
#func refresh_item(item_name): ## eseme värskendamine
	#print("<PLAYER>: eseme värskendamine ---")
	#if Global.player_holding_item == true:
		#hold_item(item_name)
	#else:
		#release_item(item_name)
#
#
## Kehaosade animatsiooni funktsioonid
#
#func idle_Anim(): # Tavaline seismise poos
	#hand1_rotation.rotation = move_toward(hand1_rotation.rotation , 0, 0.1) # Käte asendi üleminek liikumiselt seismise poosi
	#hand2_rotation.rotation = move_toward(hand2_rotation.rotation, 0, 0.1)
	#leg1_pos.position.y = move_toward(leg1_pos.position.y, 6.3, 0.2) # Jalgade asendi üleminek liikumiselt seismise poosi
	#leg2_pos.position.y = move_toward(leg2_pos.position.y, 6.3, 0.2)
#
#
#func walking_HandsAnim(): # käte liikumise animatsioon kõndimisel
	#if hand1_rotation.rotation_degrees < -14.6:
		#hand1_rotation_switch = true
		#
	#if hand1_rotation.rotation_degrees > 14.6:
		#hand1_rotation_switch = false
		#
	#if hand1_rotation_switch == true:
		#hand1_rotation.rotation_degrees += 3
	#if hand1_rotation_switch == false:
		#hand1_rotation.rotation_degrees += -3
		#
		#
	#if hand2_rotation.rotation_degrees < -14.9:
		#hand2_rotation_switch = true
		#
	#if hand2_rotation.rotation_degrees > 14.9:
		#hand2_rotation_switch = false
		#
	#if hand2_rotation_switch == true:
		#hand2_rotation.rotation_degrees += 3
	#if hand2_rotation_switch == false:
		#hand2_rotation.rotation_degrees += -3
#
#func walking_LegsAnim(): # jalgade kõndmimise animatsioon
	#if leg1_pos.position.y < 5:
		#leg1_pos_switch = true
		#
	#if leg1_pos.position.y > 6.1:
		#leg1_pos_switch = false
		#
	#if leg1_pos_switch == true:
		#leg2_pos_switch = false
		#leg1_pos.position.y += 0.15
	#if leg1_pos_switch == false:
		#leg1_pos.position.y += -0.15
#
#
	#if leg2_pos.position.y < 5:
		#leg2_pos_switch = true
		#
	#if leg2_pos.position.y > 6.1:
		#leg2_pos_switch = false
		#
	#if leg2_pos_switch == true:
		#leg1_pos_switch = false
		#leg2_pos.position.y += 0.15
	#if leg2_pos_switch == false:
		#leg2_pos.position.y += -0.15
	#
#
#
#
#func _on_console_focus_entered():
	#console_focus = true
#
#
#func _on_console_text_set():
	#pass # Replace with function body.
