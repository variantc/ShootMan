extends Node

signal player_ready(player_node: Player)
signal world_ready(world_node: World)
signal enemy_spawner_ready(enemy_spawner_node: EnemySpawner)

var player : Player
var world : World
var world_generator : WorldGenerator
var enemy_spawner : EnemySpawner
var upgrade_manager : UpgradeManager


func get_closest_location(my_loc : Vector2, other_locs : Array[Vector2]) -> Vector2:
	var d : float = INF
	var closest := Vector2(INF, INF)
	for v in other_locs:
		var d_temp = my_loc.distance_squared_to(v)
		if d_temp < d:
			closest = v
			d = d_temp
	return closest

func register_node(node) -> void:
	if node is Player:
		if exists_warning(player):
			return
		player = node as Player
		player_ready.emit(player)
	elif node is World:
		if exists_warning(world):
			return
		world = node as World
		world_ready.emit(world)
	elif node is WorldGenerator:
		if exists_warning(world_generator):
			return
		world_generator = node as WorldGenerator
	elif node is UpgradeManager:
		if exists_warning(world_generator):
			return
		upgrade_manager = node as UpgradeManager
		print_debug(upgrade_manager.name)
	elif node is EnemySpawner:
		if exists_warning(enemy_spawner):
			return
		enemy_spawner = node as EnemySpawner
		enemy_spawner_ready.emit(enemy_spawner)
	else:
		push_error("Attempting to register unexpected node: " + node.name)
	
func exists_warning(reference) -> bool:
	if reference != null:
		push_warning("Attempting to register " + reference.name + " when one already exists")
		return true
	return false
