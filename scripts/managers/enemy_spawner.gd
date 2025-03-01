extends Node
class_name EnemySpawner

@export_group("Scenes")
@export var enemy_standard_scene : PackedScene
@export var enemy_spiral_scene : PackedScene
@export var enemy_missile_scene : PackedScene
@export var enemy_laser_scene : PackedScene
@export var attack_group_scene : PackedScene

@export_group("Spawn Times")
@export var spawn_enemy_standard_time : float
@export var spawn_enemy_spiral_time : float
@export var spawn_enemy_missile_time : float
@export var spawn_enemy_laser_time : float
@export var spawn_group_time : float
@export var spawn_inc_time : float


var spawn_nests : Array[EnemyNest]

var enemy_list : Array[EnemyStandard]

var spawn_enemy_standard_counter = 0
var spawn_enemy_spiral_counter = 0
var spawn_enemy_missile_counter = 0
var spawn_enemy_laser_counter = 0
var spawn_group_counter = 0
var inc_counter = 0


func _ready():
	Refs.register_node(self)
	SignalBus.enemy_nest_destroyed.connect(_on_enemy_nest_destroyed)
	#var node_children = get_children()
	#for n in node_children:
		#spawn_nests.append(n as EnemyNest)


func register_nest(nest : EnemyNest):
	spawn_nests.append(nest)


func _process(delta):
	if Refs.world.NO_ENEMIES:
		return
	_run_spawn_enemy_standard_timer(delta)
	_run_spawn_enemy_spiral_timer(delta)
	_run_spawn_enemy_missile_timer(delta)
	_run_spawn_enemy_laser_timer(delta)
	_run_spawn_group_timer(delta)
	_run_spawn_increment_timer(delta)


func _run_spawn_enemy_standard_timer(delta) -> void:
	spawn_enemy_standard_counter += delta
	if spawn_enemy_standard_counter > spawn_enemy_standard_time:
		spawn_enemy_standard_counter = 0
		_spawn_enemy(enemy_standard_scene)
		
		
func _run_spawn_enemy_spiral_timer(delta) -> void:
	spawn_enemy_spiral_counter += delta
	if spawn_enemy_spiral_counter > spawn_enemy_spiral_time:
		spawn_enemy_spiral_counter = 0
		_spawn_enemy(enemy_spiral_scene)
		
	
func _run_spawn_enemy_missile_timer(delta) -> void:
	spawn_enemy_missile_counter += delta
	if spawn_enemy_missile_counter > spawn_enemy_missile_time:
		spawn_enemy_missile_counter = 0
		_spawn_enemy(enemy_missile_scene)
		
	
func _run_spawn_enemy_laser_timer(delta) -> void:
	spawn_enemy_laser_counter += delta
	if spawn_enemy_laser_counter > spawn_enemy_laser_time:
		spawn_enemy_laser_counter = 0
		_spawn_enemy(enemy_laser_scene)
		
		
func _run_spawn_group_timer(delta) -> void:
	spawn_group_counter += delta
	if spawn_group_counter > spawn_group_time:
		spawn_group_counter = 0
		_spawn_attack_group()
		
		
func _run_spawn_increment_timer(delta) -> void:
	inc_counter += delta
	if inc_counter >= spawn_inc_time:
		inc_counter = 0
		spawn_enemy_standard_time *= 0.9
		spawn_enemy_spiral_counter *= 0.9
	
		
func _spawn_attack_group() -> void:
	var attack_group = attack_group_scene.instantiate()
	self.add_child(attack_group)
	attack_group.global_position = %Player.global_position
	for enemy : EnemyStandard in attack_group.get_children():
		enemy_list.append(enemy)
		#_setup_enemy(enemy, enemy.global_position)
	
		
func _spawn_enemy(enemy_scene : PackedScene) -> void:
	var enemy = enemy_scene.instantiate() #as EnemyStandard
	self.add_child(enemy)
	# Previously spawn randomly just off screen:
	#_setup_enemy(enemy, _get_random_edge_position())
	# Now use EnemyNest:
	var enemy_nest = spawn_nests.pick_random()
	if enemy_nest == null:
		push_warning("No enemy nest to spawn to")
		return
	_setup_enemy(enemy, enemy_nest.global_position)
	

func _setup_enemy(enemy, spawn_pos : Vector2) -> void:
	SignalBus.enemy_spawned.emit(enemy)
	enemy_list.append(enemy)
	enemy.enemy_setup(spawn_pos)
	

func _get_random_edge_position() -> Vector2 :
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_width = viewport_rect.size.x
	var screen_height = viewport_rect.size.y
	
	var offset := 100.0
	
	var temp_pos
	
	match randi() % 4:
		0: # Top edge
			temp_pos = Vector2(randf() * screen_width + offset, -offset)
		1: # Bottom edge
			temp_pos = Vector2(randf() * screen_width, screen_height + offset)
		2: # Left edge
			temp_pos = Vector2(-offset, randf() * screen_height)
		3: # Right edge
			temp_pos = Vector2(screen_width + offset, randf() * screen_height)
				
	return temp_pos + %Player.global_position - %Player.start_pos


func remove_enemy_from_list(enemy : EnemyStandard) -> void:
	enemy_list.remove_at(enemy_list.find(enemy))
	

func remove_nest_from_list(nest : EnemyNest) -> void:
	spawn_nests.remove_at(spawn_nests.find(nest))
	
	
func _on_enemy_nest_destroyed(nest : EnemyNest):
	remove_nest_from_list(nest)
