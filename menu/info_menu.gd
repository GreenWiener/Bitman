extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.language == "english":
		lang_english()
	elif Global.language == "skibidi":
		lang_skibidi()


func lang_english():
	$CanvasLayer/Control/Label/H1.text = "Game"
	$CanvasLayer/Control/Label/H2.text = "Author"
	$CanvasLayer/Control/Label/text.text = "Bitman is an educational game that aims to introduce the player to computer components and their role in the operation of a computer. In the process, the player learns, among other things, the binary code, converting the bill from the binary system to the decimal system and vice versa.\n \nWatch the demo video to get a better overview of the game.\n \nPrevious/future versions of the game can be downloaded\nThe game source code is also up there.\n \nThe game is created with the Godot game engine.\n\n\n\n\n\n\nThe author of the game, Magnus Pikksaar, created this game for the yearbook of the 11th grade of Tartu Waldorf Gymnasium. The author started programming the game in October 2023. The main part of the game was completed by the summer of 2024, but the author will continue to improve the game as long as he can."
	$CanvasLayer/Control/Label/DemoButton.position.x = 116
	$CanvasLayer/Control/Label/LinkButton.text = "GitHub"
	$CanvasLayer/Control/Label/LinkButton.position.x = 110

func lang_skibidi():
	$CanvasLayer/Control/Label/H1.text = "Game"
	$CanvasLayer/Control/Label/H2.text = "Author"
	$CanvasLayer/Control/Label/text.text = "Bitman is an educational game that aims to introduce the player to computer components and their role in the operation of a computer. In the process, the player learns, among other things, the binary code, converting the bill from the binary system to the decimal system and vice versa.\n \nWatch the demo video to get a better overview of the game.\n \nPrevious/future versions of the game can be downloaded\nThe game source code is also up there.\n \nThe game is created with the Godot game engine.\n\n\n\n\n\n\nThe author of the game, Magnus Pikksaar, created this game for the yearbook of the 11th grade of Tartu Waldorf Gymnasium. The author started programming the game in October 2023. The main part of the game was completed by the summer of 2024, but the author will continue to improve the game as long as he can."
	$CanvasLayer/Control/Label/DemoButton.position.x = 116
	$CanvasLayer/Control/Label/LinkButton.text = "GitHub"
	$CanvasLayer/Control/Label/LinkButton.position.x = 110
