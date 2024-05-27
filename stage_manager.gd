extends CanvasLayer

#const MAIN = ("res://world/world.tscn")
#const CPU = ("res://world/cpu.tscn")

func _ready():
	get_node("ColorRect").hide()

func changeScene(stage_path): ## stseeni vahetamise funktsioon
	print("========== Stseen -> ", stage_path, " ==========")
	Global.item_bodies_list = []
	get_node("ColorRect").show()
	get_node("AnimationPlayer").play("TransIn") # animatsiooni "TransIn" mängimine
	await get_node("AnimationPlayer").animation_finished # animatsiooni "TransIn" lõpuni mängimise ootamine
	
	get_tree().change_scene_to_file(stage_path) # stseeni muutmine
	
	get_node("AnimationPlayer").play("TransOut") # animatsiooni "TransOut" mängimine
	await get_node("AnimationPlayer").animation_finished # animatsiooni "TransOut" lõpuni mängimise ootamine
	get_node("ColorRect").hide()
	
