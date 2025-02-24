extends EnemyStandard
class_name EnemyMissile


@export var radius: float = 350.0
@export var orbit_speed: float = 0.05


var orbit_direction : int = 1
var radius_factor : float = 1.0

func _ready():
	super._ready()
	
	# Set orbit direction and rotate sprite 90 degrees in that direction
	orbit_direction = 1 if randi_range(0,1) else -1
	if orbit_direction == 1:
		%Sprite2D.rotation = PI 
		
	radius_factor *= randf_range(0.95,1.1)


func _physics_process(delta: float) -> void:
	_move_and_rotate(delta, target)
	
	# Set shot direction 90 deg to movement based on orbit direction
	var shot_dir = Vector2.RIGHT.rotated(global_rotation + orbit_direction * PI/2)
	%ShootComponent.shoot(delta, shot_dir)
	
	
func _move_and_rotate(delta, traget_pos):
	var to_target = (global_position - traget_pos).normalized()
	var rotate_ang = PI/6 * orbit_direction
	var strafe_target = Refs.player.global_position \
			+ (to_target * radius_factor * radius).rotated(rotate_ang)
	
	if Refs.world.DEBUG:
		%DebugLine.clear_points()
		%DebugLine.global_position = Vector2.ZERO
		%DebugLine.global_rotation = 0
		%DebugLine.add_point(global_position)
		%DebugLine.add_point(strafe_target)
		
	if Refs.world.DEBUG:
		Refs.debug_draw_direction(
			"sprite_facing_" + str(get_instance_id()),
			global_position,
			Vector2.RIGHT.rotated(global_rotation + %Sprite2D.rotation),
			50.0,
			"direction"
		)
			
	movement_component.move_and_rotate(movement_resource, strafe_target, delta)
