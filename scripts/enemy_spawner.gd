extends Node
class_name EnemySpawner


signal enemy_spawned(enemy : EnemyStandard)
signal enemy_killed(enemy : EnemyStandard, audio_stream : AudioStreamPlayer2D)

@export var world : World
@export var enemy_standard_scene : PackedScene
@export var enemy_spiral_scene : PackedScene
@export var attack_group_scene : PackedScene
@export var spawn_enemy_standard_time : float
@export var spawn_enemy_spiral_time : float
@export var spawn_group_time : float
@export var spawn_inc_time : float

var enemy_list : Array[EnemyStandard]

var spawn_enemy_standard_counter = 0
var spawn_enemy_spiral_counter = 0
var spawn_group_counter = 0
var inc_counter = 0


func _process(delta):
	_run_spawn_enemy_standard_timer(delta)
	_run_spawn_enemy_spiral_timer(delta)
	_run_spawn_group_timer(delta)
	_run_spawn_increment_timer(delta)


func _run_spawn_enemy_standard_timer(delta):
	spawn_enemy_standard_counter += delta
	if spawn_enemy_standard_counter > spawn_enemy_standard_time:
		spawn_enemy_standard_counter = 0
		_spawn_enemy(enemy_standard_scene)
		
		
func _run_spawn_enemy_spiral_timer(delta):
	spawn_enemy_spiral_counter += delta
	if spawn_enemy_spiral_counter > spawn_enemy_spiral_time:
		spawn_enemy_spiral_counter = 0
		_spawn_enemy(enemy_spiral_scene)
		
	
func _run_spawn_group_timer(delta):
	spawn_group_counter += delta
	if spawn_group_counter > spawn_group_time:
		spawn_group_counter = 0
		_spawn_attack_group()
		
		
func _run_spawn_increment_timer(delta):
	inc_counter += delta
	if inc_counter >= spawn_inc_time:
		inc_counter = 0
		spawn_enemy_standard_time *= 0.9
		spawn_enemy_spiral_counter *= 0.9
	
		
func _spawn_attack_group():
	var attack_group = attack_group_scene.instantiate()
	self.add_child(attack_group)
	for enemy : EnemyStandard in attack_group.get_children():
		_setup_enemy(enemy, enemy.global_position)
	
		
func _spawn_enemy(enemy_scene : PackedScene):
	var enemy = enemy_scene.instantiate() #as EnemyStandard
	self.add_child(enemy)
	_setup_enemy(enemy, _get_random_edge_position())
	

func _setup_enemy(enemy, spawn_pos : Vector2):
	enemy.enemy_killed.connect(_on_enemy_killed)
	enemy_spawned.emit(enemy)
	enemy_list.append(enemy)
	enemy.enemy_setup(world, spawn_pos)
	

func _get_random_edge_position():
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_width = viewport_rect.size.x
	var screen_height = viewport_rect.size.y
	
	var offset := 25.0
	
	match randi() % 4:
		0: # Top edge
			return Vector2(randf() * screen_width + offset, -offset)
		1: # Bottom edge
			return Vector2(randf() * screen_width, screen_height + offset)
		2: # Left edge
			return Vector2(-offset, randf() * screen_height)
		3: # Right edge
			return Vector2(screen_width + offset, randf() * screen_height)
				

func _on_enemy_killed(enemy : EnemyStandard, audio_stream : AudioStreamPlayer2D):
	enemy_list.remove_at(enemy_list.find(enemy))
	enemy_killed.emit(enemy, audio_stream)
