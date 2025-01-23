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


func _ready():
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
	_move_and_rotate(delta)
	
	
func _move_and_rotate(delta):
	if world == null:
		print("Error: EnemyStandard.world not assigned - has .enemy_setup() run?")
	
	movement_component.move_and_rotate(movement_resource, world.player.global_position, delta)
	# Set the rotation in the shader to adjust normals for lighting
	%Sprite2D.material.set_shader_parameter("object_rotation", rotation - PI)
	

func enemy_setup(game_world: World, pos : Vector2):
	self.world = game_world
	global_position = pos


func hit(bullet : Bullet, bullet_direction : Vector2, bullet_speed : float):
	_knock_back(bullet_direction, bullet_speed)
	
	var prev_health = health
	var bullet_damage = health
	health -= bullet.strength
	_show_damage(prev_health, health)
	bullet.strength -= bullet_damage


func _show_damage(prev, current):
	var dam_time = 0.3
	# Create and configure a single tween
	var tween = create_tween() as Tween
	
	# Ensure queue_free() is only called after tween completes
	tween.finished.connect(func(): if health <= 0 : queue_free())
	if health <= 0:
		_die()
	
	var start_health_left = prev / _start_health
	# Update shader to reflect new health
	var health_left = max(current / _start_health, 0)
	
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
