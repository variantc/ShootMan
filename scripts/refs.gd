extends Node

signal player_ready(player_node)
signal world_ready(player_node)

var player : Player
var world : World
	
	
func get_closest_location(my_loc : Vector2, other_locs : Array[Vector2]) -> Vector2:
	var d : float = INF
	var closest := Vector2(INF, INF)
	for v in other_locs:
		var d_temp = my_loc.distance_squared_to(v)
		if d_temp < d:
			closest = v
			d = d_temp
	return closest


func register_player(p_node : Player) -> void:
	if player != null:
		push_warning("Attempting to register player when one already exists")
		return
	player = p_node
	player_ready.emit(player)


func register_world(w_node : World) -> void:
	if world != null:
		push_warning("Attempting to register world when one already exists")
		return
	world = w_node
	world_ready.emit(world)
