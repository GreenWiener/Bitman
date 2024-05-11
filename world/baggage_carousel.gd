extends TileMap
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#for el in Global.item_bodies_list:
		#if el.item_pos_int2 != null:
			##print(el.item_pos_int2)
			##set_cell(0, el.item_pos_int2, 0, Vector2i(1,1))
			#if self.get_cell_atlas_coords(0, el.item_pos_int2) == Vector2i(1,1) or self.get_cell_atlas_coords(0, el.item_pos_int2) == Vector2i(3,1):
				##print("##### right")
				#el.position.x += 0.05
			#if self.get_cell_atlas_coords(0, el.item_pos_int2) == Vector2i(2,1):
				##print("##### right_diag")
				#el.position += Vector2(0.03, -0.02)
			#if self.get_cell_atlas_coords(0, el.item_pos_int2) == Vector2i(3,0):
				#el.position.y += -0.05
				##print("##### up")
		#
		#
