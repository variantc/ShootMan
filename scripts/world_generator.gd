extends Node2D
class_name WorldGenerator

@export_group("Chunk Properties")
@export var CHUNK_SIZE = 1000  # Size of each chunk in pixels
@export var MIN_DISTANCE_BETWEEN_POINTS = 500  # Minimum distance between spawned objects
@export var UPGRADES_PER_CHUNK = 4
@export var NESTS_PER_CHUNK = 1
@export var chunk_check_interval := 5
var check_timer := 0.0

@export_group("Scenes")
@export var upgrade_node_scene : PackedScene
@export var enemy_nest_scene : PackedScene

var active_chunks = {}  # Dictionary to track generated chunks
var rng = RandomNumberGenerator.new()
var last_checked_chunk := Vector2.ZERO


func _ready():
	rng.randomize()
	Refs.register_node(self)
	Refs.enemy_spawner_ready.connect(_on_enemy_spawner_ready)


func _process(delta: float) -> void:
	# Only check periodically to avoid constant chunk calculations
	check_timer += delta
	if check_timer >= chunk_check_interval:
		check_timer = 0.0
		if Refs.player:  # Make sure player exists
			update_chunks(Refs.player.global_position)


func _on_enemy_spawner_ready(_enemy_spawner):
	update_chunks(Vector2.ZERO)


# Called when player moves to generate nearby chunks
func update_chunks(player_position: Vector2):
	var current_chunk = get_chunk_coords(player_position)
	
	# Only regenerate if player has moved to a new chunk
	if current_chunk != last_checked_chunk or current_chunk == Vector2.ZERO:
		last_checked_chunk = current_chunk
	
		# Generate chunks in a 3x3 area around player
		for x in range(current_chunk.x - 1, current_chunk.x + 2):
			for y in range(current_chunk.y - 1, current_chunk.y + 2):
				var chunk_key = str(x) + "," + str(y)
				if not active_chunks.has(chunk_key):
					generate_chunk(Vector2(x, y))
					active_chunks[chunk_key] = true
					

# Convert world position to chunk coordinates
func get_chunk_coords(pos: Vector2) -> Vector2:
	return Vector2(
		floor(pos.x / CHUNK_SIZE),
		floor(pos.y / CHUNK_SIZE)
	)

# Generate content for a new chunk
func generate_chunk(chunk_coords: Vector2):
	var chunk_origin = chunk_coords * CHUNK_SIZE
	var points = generate_poisson_points(
		chunk_origin,
		CHUNK_SIZE,
		MIN_DISTANCE_BETWEEN_POINTS,
		UPGRADES_PER_CHUNK + NESTS_PER_CHUNK
	)
	
	# Shuffle points to randomize which become upgrades vs nests
	points.shuffle()
	
	# Spawn upgrade nodes
	for i in range(UPGRADES_PER_CHUNK):
		if i < points.size():
			spawn_upgrade(points[i])
			print_debug("upgrade node at: " + str(points[i]))
	
	# Spawn enemy nests
	for i in range(UPGRADES_PER_CHUNK, UPGRADES_PER_CHUNK + NESTS_PER_CHUNK):
		if i < points.size():
			spawn_nest(points[i])
			print_debug("spawned nest at: " + str(points[i]))

# Generate points using Poisson Disc Sampling
func generate_poisson_points(origin: Vector2, size: float, min_dist: float, num_points: int) -> Array:
	var points = []
	var attempts = 30  # Maximum attempts to place each point
	
	while points.size() < num_points:
		var valid_point = false
		var new_point = Vector2.ZERO
		
		for _attempt in range(attempts):
			new_point = Vector2(
				origin.x + rng.randf_range(0, size),
				origin.y + rng.randf_range(0, size)
			)
			
			# Check if point is far enough from existing points
			valid_point = true
			for existing_point in points:
				if new_point.distance_to(existing_point) < min_dist:
					valid_point = false
					break
			
			if valid_point:
				points.append(new_point)
				break
		
		if not valid_point:
			break  # If we couldn't place a point after max attempts, stop trying
	
	return points

func spawn_upgrade(pos: Vector2):
	var upgrade = upgrade_node_scene.instantiate()
	upgrade.position = pos
	add_child(upgrade)

func spawn_nest(pos: Vector2):
	var nest = enemy_nest_scene.instantiate()
	nest.position = pos
	Refs.enemy_spawner.register_nest(nest)
	add_child(nest)
