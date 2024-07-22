extends Control


func _ready():
	$Label.hide()
	$Label.pivot_offset = Vector2($Label.size.x / 2, 10)


func popup(popup_text, pos):
	if str(pos) != "cursor":
		print("🗯 <PopUp>: '", popup_text, "'")
	
	if str(pos) == "mouse":
		$Label.position = get_local_mouse_position() - Vector2($Label.size.x / 2, 10)
	elif str(pos) == "player":
		$Label.position = Global.player_position *10 - Vector2($Label.size.x / 2, 10)
	elif str(pos) == "cursor":
		$Label.position = get_local_mouse_position() - Vector2($Label.size.x / 2, 15)
	else:
		$Label.position = pos - Vector2($Label.size.x / 2, 10)
	$Label.text = popup_text
	$AnimationPlayer.play("PopUp")
	
	await $AnimationPlayer.animation_finished # animatsiooni "PopUp" lõpuni mängimise ootamine
	queue_free()
