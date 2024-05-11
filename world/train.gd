extends Node2D

var speed_num = 0

func _ready() -> void:
	Global._train = self
	position = Global.train_pos

	if Global.next_train_direction == true:
		Global.train_direction = !Global.train_direction
		Global.next_train_direction = false
	
	if Global.train_direction == true:
		pass
	elif Global.train_direction == false:
		$body.scale.x = $body.scale.x * -1
		$"body/interact-area".scale.x = $"body/interact-area".scale.x * -1
		$"body/interact-area2".scale.x = $"body/interact-area2".scale.x * -1

func _physics_process(delta):
	Global.train_pos = position
	
	if Global.train_driving == true and speed_num < 40:
		speed_num += 0.07
		print(speed_num)
	
	if Global.train_driving == true and Global.player_in_menu != true:
		
		if Global.train_direction == true:
			position.x += speed_num * delta
			$body.scale.x = 0.45
		elif Global.train_direction == false:
			position.x += -(speed_num) * delta
			$body.scale.x = -0.45
	

func _on_stop_collision_area_entered(area):
	if "train_stop_area" in area.name:
		print("sTOP YHE THRAION: ", area)
		Global.train_driving = false
		Global.next_train_direction = true
		##Global.train_direction = !Global.train_direction
		
		if Global.train_direction == true: ### ??
			position.x += -0.4
		elif Global.train_direction == false:
			position.x += 0.4


var doors_open = false
func interact_doors():
	print('opening doors')
	var tween = self.create_tween()
	var tween2 = self.create_tween()
	if doors_open == false:
		$body/TrainDoorsCollision/train_doors_collision.disabled = true
		tween.tween_property($body/TrainDoor1, "position", Vector2(-8.2,1.5), 0.8)
		tween2.tween_property($body/TrainDoor2, "position", Vector2(9.2,1.5), 0.8)
	else:
		tween.tween_property($body/TrainDoor1, "position", Vector2(-2.4,1.5), 0.8)
		tween2.tween_property($body/TrainDoor2, "position", Vector2(3.39,1.5), 0.8)
		$body/TrainDoorsCollision/train_doors_collision.disabled = false
	doors_open = !doors_open






