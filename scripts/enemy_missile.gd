extends EnemyStandard

@export var radius: float = 350.0
@export var orbit_speed: float = 0.05

@export var current_gun : GunResource

var _orbit_angle: float = 0.0

func _ready():
	world = get_tree().root.get_child(1)


func _process(delta: float) -> void:
	_move_and_rotate(delta)
	%ShootComponent.shoot(delta, current_gun, 1)
	
	
func _move_and_rotate(delta):
	var to_player = (global_position - world.player.global_position).normalized()
	var strafe_target = \
		world.player.global_position + (to_player * radius).rotated(PI/6)
	
	%DebugRect.global_position = strafe_target
	
	#var reverse = false
	#if global_position.distance_squared_to(player.global_position) < radius * radius:
		#reverse = true
	#else:
		#reverse = false
	
	movement_component.move_and_rotate(
		delta, 
		self, 
		strafe_target,
		speed,
		ang_acc)
