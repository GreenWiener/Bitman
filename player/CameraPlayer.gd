extends Camera2D

#@onready var tween = self.create_tween()

func _ready():
	#pan_right()
	pass

var tween_pan_right = false
var tween_pan_left = false
var tween_pan_default = false

func pan_right():
	var tween = self.create_tween()
	tween.tween_property(self, "position", Vector2(4,0), 0.3)

func pan_left():
	var tween = self.create_tween()
	tween.tween_property(self, "position", Vector2(-4,0), 0.3)

func pan_default():
	var tween = self.create_tween()
	tween.tween_property(self, "position", Vector2(0,-4), 0.3)


func zoom_in():
	if self.zoom < Vector2(5,5):
		var tween = self.create_tween()
		tween.tween_property(self, "zoom", self.zoom + self.zoom/3 + Vector2(1,1), 0.3)

func zoom_out():
	if self.zoom > Vector2(2,2):
		var tween = self.create_tween()
		tween.tween_property(self, "zoom", self.zoom - self.zoom/1.3 + Vector2(1,1), 0.3)
			
	#if self.zoom < Vector2(2,2):
		#self.zoom = Vector2(2,2)

#func zooming(zoom_amount): ###<<<<<<< DEVELOPE THIS
	#var tween = self.create_tween()
	#tween.tween_property(self, "zoom", self.zoom - zoom_amount, 0.3)
	#print("zooming-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-")


func _process(_delta):
	Global.camera_zoom = self.zoom
	
	if Global.player_holding_item == true:
		if Global.player_skeleton.scale.x == 1 and tween_pan_right == false:
			pan_right()
			tween_pan_right = true
			tween_pan_left = false
			tween_pan_default = false
		elif Global.player_skeleton.scale.x == -1 and tween_pan_left == false:
			pan_left()
			tween_pan_left = true
			tween_pan_right = false
			tween_pan_default = false
		
	else:
		if tween_pan_default == false:
			pan_default()
			tween_pan_default = true
			tween_pan_right = false
			tween_pan_left = false
		


func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and Global.player_in_menu != true and Global._task_menu.disable_zoom == false:
			# sisse suumimine
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
				#self.zoom.x += 0.5
				#self.zoom.y += 0.5
				#self.zoom.x = min(self.zoom.x, 7)
				#self.zoom.y = min(self.zoom.y, 7)
				###print("+zoom: ", self.zoom)
				
			# välja suumimine
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()
				#self.zoom.x += -0.5
				#self.zoom.y += -0.5
				#self.zoom.x = max(self.zoom.x, 1.6)
				#self.zoom.y = max(self.zoom.y, 1.6)
				###print("-zoom: ", self.zoom)



##### NOT WORK ^-^ O_o
	var positions : Array = [Vector2(), Vector2()]

	if event is InputEventScreenTouch:
		positions[event.index] = event.position
		if event.index == 1:
			var zoom_amount = (positions[0] - positions[1]).length()
			Global.PopUpText(zoom_amount, "player", Vector2.ZERO)
