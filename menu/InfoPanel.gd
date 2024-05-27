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
@export_file var sprite = ""



var interact_instance = load("res://menu/text_dialog.tscn").instantiate()


var player

var player_in_menu = false
var in_interact_area = false

func _ready():
	if sprite == "":
		$Sprite2D.texture = load("res://world/gray_sign.png")
	elif sprite == "none":
		$Sprite2D.hide()
	else:
		$Sprite2D.texture = load(sprite)
	
	if self.scale.x == -1:
		$interaction_label.scale.x = -0.12

func _physics_process(_delta): # E interaction
	if Input.is_action_pressed("Interact_e"):
		$interaction_label.modulate = "00ff47" # green
	else:
		$interaction_label.modulate = "ffffff" # white
	
	if player_in_menu == true and Input.is_action_just_released("Interact_e"):
		print("close dialog.")
		player_in_menu = false
		player.get_node("CanvasLayer").remove_child(interact_instance)

	elif player_in_menu == false and in_interact_area == true and Input.is_action_just_released("Interact_e"):
		print("open dialog.")
		player_in_menu = true
		player.get_node("CanvasLayer").add_child(interact_instance)
		interact_instance.get_child(1).text = text



func _on_body_entered(body):
	if body is Player:
		player = body
		in_interact_area = true
		
		$interaction_label.show()



func _on_body_exited(body):
	if body is Player:
		in_interact_area = false	
		body.get_node("CanvasLayer").remove_child(interact_instance)
		
		$interaction_label.hide()

