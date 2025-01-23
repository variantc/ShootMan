extends EnemyStandard
class_name EnemyMissile


@export var radius: float = 350.0
@export var orbit_speed: float = 0.05

@export var current_weapon : WeaponResource

var orbit_direction : int = 1
var radius_factor : float = 1.0

func _ready():
	super._ready()
	
	if randi_range(0,1):
		orbit_direction = -1
		
	radius_factor *= randf_range(0.95,1.1)


func _process(delta: float) -> void:
	_move_and_rotate(delta, target)
	%ShootComponent.shoot(delta, current_weapon)
	
	
func _move_and_rotate(delta, target):
	var to_player = (global_position - target).normalized()
	var rotate_ang = PI/6 * orbit_direction
	var strafe_target = \
		world.player.global_position \
			+ (to_player * radius_factor * radius).rotated(rotate_ang)
	
	if world.DEBUG:
		%DebugLine.clear_points()
		%DebugLine.global_position = Vector2.ZERO
		%DebugLine.global_rotation = 0
		%DebugLine.add_point(global_position)
		%DebugLine.add_point(strafe_target)
	
	movement_component.move_and_rotate(movement_resource, strafe_target, delta)
