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

##########################################################################
# SINGLETON HANGLING
##########################################################################
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
		if world.DEBUG:
			_create_debug_node()
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


##########################################################################
# DEBUG VISUALISATION
##########################################################################
var debug_lines := {}
var debug_points := {}
var debug_colors := {
	"default": Color.WHITE,
	"direction": Color.GREEN,
	"target": Color.RED,
	"path": Color.YELLOW,
	"collision": Color.ORANGE,
	"error": Color.MAGENTA
}

const DEBUG_NODE_PATH = "res://scenes/debug_draw.tscn"

func _create_debug_node():
	var debug_draw_scene = load(DEBUG_NODE_PATH)
	var debug_draw = debug_draw_scene.instantiate()
	add_child(debug_draw)
	

# Register a debug line to be drawn
func debug_draw_line(id: String, start_pos: Vector2, end_pos: Vector2, type: String = "default", duration: float = 0.0) -> void:
	debug_lines[id] = {
		"start": start_pos,
		"end": end_pos,
		"color": debug_colors.get(type, debug_colors.default),
		"width": 2.0,
		"time": duration,
		"created": Time.get_ticks_msec()
	}
	
	if duration > 0:
		get_tree().create_timer(duration).timeout.connect(func(): debug_lines.erase(id))

# Register a debug point to be drawn
func debug_draw_point(id: String, position: Vector2, radius: float = 5.0, type: String = "default", duration: float = 0.0) -> void:
	debug_points[id] = {
		"position": position,
		"radius": radius,
		"color": debug_colors.get(type, debug_colors.default),
		"time": duration,
		"created": Time.get_ticks_msec()
	}
	
	if duration > 0:
		get_tree().create_timer(duration).timeout.connect(func(): debug_points.erase(id))

# Clear all debug visualizations
func clear_debug_draws() -> void:
	debug_lines.clear()
	debug_points.clear()

# Add a helper specifically for direction visualization
func debug_draw_direction(id: String, origin: Vector2, direction: Vector2, length: float = 100.0, type: String = "direction", duration: float = 0.0) -> void:
	debug_draw_line(id, origin, origin + direction.normalized() * length, type, duration)

# Draw a target position with connecting line
func debug_draw_target(id: String, from_pos: Vector2, target_pos: Vector2, type: String = "target", duration: float = 0.0) -> void:
	debug_draw_line(id + "_line", from_pos, target_pos, type, duration)
	debug_draw_point(id + "_point", target_pos, 5.0, type, duration)
