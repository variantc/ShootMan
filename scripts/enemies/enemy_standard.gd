extends CharacterBody2D
class_name EnemyStandard


@export var speed : float
@export var ang_acc : float
@export var health : float
var _start_health : float

@onready var movement_component = $MovementComponent as MovementComponent
@onready var movement_resource : MovementResource

var world : World
var player : Player
var target : Vector2
var target_player = true

func _ready():
	SignalBus.upgrade_node_claim_status_changed.connect(_on_upgrade_node_claim_state_changed)
	_start_health = health
	
	movement_resource = MovementResource.new(self, speed, ang_acc)
	_randomise_shader_noise()


func _randomise_shader_noise():	
	# Make each material unique for multiple instances of enemy
	%Sprite2D.material = %Sprite2D.material.duplicate()
	
	# Get and duplicate the noise texture
	var noise_texture: NoiseTexture2D = %Sprite2D.material.get_shader_parameter("burn_noise").duplicate()
	
	# Duplicate the noise generator
	noise_texture.noise = noise_texture.noise.duplicate()
	
	# Set the new noise texture on the material
	%Sprite2D.material.set_shader_parameter("burn_noise", noise_texture)
	
	if not noise_texture:
		printerr("No noise_texture found")
		
	# Get the noise generator and set its seed
	var noise = noise_texture.noise
	noise.seed = randi() % 10000


func _process(delta):
	if target_player:
		target = world.player.global_position
		
	_move_and_rotate(delta, target)
	
	
func _move_and_rotate(delta : float, target_pos : Vector2):
	if world == null:
		print("Error: EnemyStandard.world not assigned - has .enemy_setup() run?")
	
	movement_component.move_and_rotate(movement_resource, target_pos, delta)
	# Set the rotation in the shader to adjust normals for lighting
	# TODO: Change rotation offset?
	%Sprite2D.material.set_shader_parameter("object_rotation", rotation - PI)
	

func enemy_setup(game_world: World, pos : Vector2):
	self.world = game_world
	global_position = pos
	_check_for_closest_target()


# bullet hit
func hit(bullet : Bullet, bullet_direction : Vector2, bullet_speed : float):
	_knock_back(bullet_direction, bullet_speed)
	
	var prev_health = health
	var bullet_damage = health
	health -= bullet.strength
	_show_damage(prev_health, health)
	bullet.strength -= bullet_damage


# directly destroy enemy
func crash():
	_show_damage(health, 0)


func _show_damage(prev, current):
	var dam_time = 0.3
	# Create and configure a single tween
	var tween = create_tween() as Tween
	
	if current <= 0:
		# Ensure queue_free() is only called after tween completes
		tween.finished.connect(_remove_from_game)
		_die()
	
	var start_health_left = prev / _start_health
	# Update shader to reflect new health
	var health_left = max(current / _start_health, 0)
	
	tween.parallel()
	# Tween the shader health parameter and position simultaneously
	tween.tween_method(_set_shader_hp_left, start_health_left, health_left, dam_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)


func _set_shader_hp_left(hp_left: float):
	%Sprite2D.material.set_shader_parameter("hp_left", hp_left)


func _knock_back(direction: Vector2, kb_speed: float):
	var kb_red_factor = 0.075
	var kb_time = 0.3
	var kb_target_pos = global_position + direction * kb_speed * kb_red_factor

	# Create and configure a single tween
	var tween = create_tween() as Tween
		
	tween.tween_property(self, "global_position", kb_target_pos, kb_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)


func _die():
		#world.enemy_spawner.remove_enemy_from_list(self)
		SignalBus.enemy_killed.emit(self, %AudioStreamPlayer2D)
		# queue_free called in tween.finished signal
		
		
func _remove_from_game():
	queue_free()
		
		
# When the upgrade node signal is emitted, we currently get all claimed upgrade
# nodes from world and check against player position
func _on_upgrade_node_claim_state_changed(_node : UpgradeNode, _claimed : bool):
	_check_for_closest_target()
	

func _check_for_closest_target() -> void:
	var positions : Array[Vector2] 
	for n in world.claimed_upgrade_nodes:
		positions.append(n.global_position)
	positions.append(world.player.global_position)
	target = Refs.get_closest_location(global_position, positions)
	if target != world.player.position:
		target_player = false
