extends Area2D


@export var item = ""

var player = "player"
var player_instance = load("res://player/player.tscn").instantiate()
var item_texture = load("res://player/player.tscn").instantiate()

func _on_body_entered(body):
	print("item!!!")
	if body is Player:
		print("item!")
		##player = body
		##player_instance.in_interact_area = true
		
		##body.get_node("skeleton/player-arm2").add_child(item_texture)
		#print(interact_instance.get_child(1).get_child(0))
		#interact_instance.get_child(1).text = text
