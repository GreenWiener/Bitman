extends Node
class_name Ladder

func _ready():
	print("LADDeR IS READY 👙👙👙")

#var ladder_poly
#var wall_collision# = $LockerLadder_collision/StaticBody2D/wall_collision

static func create_ladder_poly(ladder_item, the_wall_collision : Object, wall_collision_clipped : Object):
	print("create_ladder_poly(", ladder_item, ", ", the_wall_collision, ", ", wall_collision_clipped, ")")
	var ladder_poly
	var wall_collision
	wall_collision = the_wall_collision
	ladder_poly = CollisionPolygon2D.new()
	ladder_poly.name = "ladder_poly"
	
	Global._world.add_child(ladder_poly) ### self
	#ladder_poly.polygon = ladder_item.position#ladder_item_poly
	# +20
	ladder_poly.polygon = [ladder_item.position + Vector2(-2.2,2), ladder_item.position + Vector2(-2.2,-15), ladder_item.position + Vector2(2.2,-15), ladder_item.position + Vector2(2.2,2)]
	
	var clip_collision = Geometry2D.clip_polygons(wall_collision.polygon, ladder_poly.polygon)
	#$LockerLadder_collision/StaticBody2D/locker_collision_clipped.polygon = clip_collision[0]
	wall_collision_clipped.polygon = clip_collision[0]
	wall_collision.disabled = true
	#ladder.disabled = true


static func delete_ladder_poly(the_ladder_poly, the_wall_collision2):
	if the_ladder_poly != null:
		the_wall_collision2.disabled = false
		the_ladder_poly.queue_free()
	


static func bob():
	print("B0B")


func bob2():
	print("B0B2")

