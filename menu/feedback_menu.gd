extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if "a1" in Global.feedback_dict:
		$PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a1.text = Global.feedback_dict["a1"]
	if "a2" in Global.feedback_dict:
		$PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a2.text = Global.feedback_dict["a2"]
	if "a3" in Global.feedback_dict:
		$PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a3.text = Global.feedback_dict["a3"]
	if "a4" in Global.feedback_dict:
		$PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a4.text = Global.feedback_dict["a4"]
	if "a5" in Global.feedback_dict:
		$PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a5.text = Global.feedback_dict["a5"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_welcome_btn_pressed():
	self.visible = false
	Global.player_in_menu = false


func _on_a_1_text_changed():
	Global.feedback_dict["a1"] = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a1.text

func _on_a_2_text_changed():
	Global.feedback_dict["a2"] = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a2.text

func _on_a_3_text_changed():
	Global.feedback_dict["a3"] = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a3.text

func _on_a_4_text_changed():
	Global.feedback_dict["a4"] = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a4.text

func _on_a_5_text_changed():
	Global.feedback_dict["a5"] = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/a5.text
