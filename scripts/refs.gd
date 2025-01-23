extends Node


func _ready():
	print_debug("Refs loaded")
	
	
func get_closest_location(my_loc : Vector2, other_locs : Array[Vector2]) -> Vector2:
	var d : float = INF
	var closest := Vector2(INF, INF)
	for v in other_locs:
		var d_temp = my_loc.distance_squared_to(v)
		if d_temp < d:
			closest = v
			d = d_temp
	return closest
