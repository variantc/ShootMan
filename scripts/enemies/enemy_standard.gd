extends CharacterBody2D
class_name EnemyStandard


@export var speed : float
@export var ang_acc : float
@export var health : float
var _start_health : float

@onready var movement_component = $MovementComponent as MovementComponent
@onready var movement_resource : MovementResource

var target : Vector2
var target_player = true

var _actual_health: float  # The real current health
var _displayed_health: float  # The health value being displayed/animated

var is_dying := false


func _ready():
	_actual_health = health
	_displayed_health = health
	_start_health = health
	
	SignalBus.upgrade_node_claim_status_changed.connect(_on_upgrade_node_claim_state_changed)
	
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
		target = Refs.player.global_position
		
	_move_and_rotate(delta, target)
	
	
func _move_and_rotate(delta : float, target_pos : Vector2):
	movement_component.move_and_rotate(movement_resource, target_pos, delta)
	# Set the rotation in the shader to adjust normals for lighting
	# TODO: Change rotation offset?
	%Sprite2D.material.set_shader_parameter("object_rotation", rotation - PI)
	

func enemy_setup(pos : Vector2):
	global_position = pos
	_check_for_closest_target()


# bullet hit
func hit(bullet : Bullet, bullet_direction : Vector2, bullet_speed : float):
	if is_dying:   # ignore additional hits if already dying
		return
	
	_knock_back(bullet_direction, bullet_speed)
	
	var bullet_damage = bullet.strength
	_actual_health -= bullet_damage
	bullet.strength -= bullet_damage

	_show_damage()
	

# directly destroy enemy
func crash():
	_actual_health = 0
	_show_damage()


var _current_damage_tween : Tween
func _show_damage():
	# If there's an existing tween running, kill it
	if _current_damage_tween and _current_damage_tween.is_running():
		_current_damage_tween.kill()
	
	var dam_time = 0.3
	
	# Create and configure a single tween
	_current_damage_tween = create_tween() as Tween
	
	if _actual_health <= 0:
		# Ensure queue_free() is only called after tween completes
		_current_damage_tween.finished.connect(_remove_from_game)
		_die()
	
	var start_health_left = _displayed_health / _start_health
	# Update shader to reflect new health
	var target_health_left = max(_actual_health / _start_health, 0)
	
	# tween.parallel()
	# Tween the shader health parameter and position simultaneously
	_current_damage_tween.tween_method(_set_shader_hp_left, start_health_left, target_health_left, dam_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)


func _set_shader_hp_left(hp_left: float):
	_displayed_health = hp_left * _start_health   # Update displayed health in the tween
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
	if is_dying:   # Don't trigger again causing multiple drops
		return
	
	is_dying = true
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
	for n in Refs.world.claimed_upgrade_nodes:
		positions.append(n.global_position)
	positions.append(Refs.player.global_position)
	target = Refs.get_closest_location(global_position, positions)
	if target != Refs.player.position:
		target_player = false
