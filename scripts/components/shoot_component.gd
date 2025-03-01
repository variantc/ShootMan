extends Node
class_name ShootComponent


@export var bullet_scene : PackedScene
@export var missile_scene : PackedScene

@export var start_weapon : WeaponResource
var current_weapon : WeaponResource

var counter : float = 0
var parent : Node

const PLAYER_LAYER_MASK := 1
const ENEMY_LAYER_MASK := 2

var _target_direction : Vector2

func _ready():
	parent = get_parent()
	current_weapon = start_weapon.duplicate()
	
	
func shoot(delta : float, target_direction : Vector2) -> void:
	_target_direction = target_direction
	
	if Refs.world.DEBUG:
		# Visualize the shooting direction
		Refs.debug_draw_direction(
			"shoot_component_" + str(get_instance_id()),
			parent.global_position,
			_target_direction,
			150.0,
			"direction"
		)
	
	if current_weapon.shot_number == 0:
		push_error("ERROR: Shot number is zero!")
		return
		
	counter += delta
	if counter > current_weapon.shot_time:
		counter = 0.0
		_loop_for_shots(current_weapon)
		

func _loop_for_shots(weapon_resource : WeaponResource):
	var base_rotation = _target_direction.angle()
	var rad_spread = weapon_resource.shot_spread * PI/180
	
	for i in range(weapon_resource.shot_number):
		var rot = base_rotation
		if weapon_resource.shot_number > 1:
			rot = base_rotation - (rad_spread)/2 + i * rad_spread/(weapon_resource.shot_number-1)
			
		var projectile

		match weapon_resource.projectile_type:
			WeaponResource.Type.BULLET:
				projectile = bullet_scene.instantiate() as Bullet
			WeaponResource.Type.MISSILE:
				projectile = missile_scene.instantiate() as Missile
			
		parent.get_parent().add_child(projectile)
			
		var weapon_stats = weapon_resource.duplicate() as WeaponResource
			
		# Offset spawn position to avoid collider issues:
		var spawn_offset = Vector2.RIGHT.rotated(rot) * 20  # Adjust 20 to whatever offset you want
		weapon_stats.projectile_position = parent.global_position + spawn_offset
		weapon_stats.rotation = rot
				
		projectile.setup(weapon_stats)
