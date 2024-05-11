extends TileMap


func _process(delta):
	for el in Global.item_bodies_list:
		if el.item_pos_int3 != null:
			if self.get_cell_atlas_coords(0, el.item_pos_int3) == Vector2i(0,0):
				#print("liigub paremale")
				el.position.x += 0.05 * delta * 150
			if self.get_cell_atlas_coords(0, el.item_pos_int3) == Vector2i(1,0):
				#print("liigub paremale üles")
				el.position += Vector2(0.03, -0.01) * delta * 150
			if self.get_cell_atlas_coords(0, el.item_pos_int3) == Vector2i(2,0):
				#print("liigub paremale üles")
				el.position += Vector2(0.02, -0.03) * delta * 150
			if self.get_cell_atlas_coords(0, el.item_pos_int3) == Vector2i(3,0):
				el.position.y += -0.05 * delta * 150
				#print("liigub üles")
