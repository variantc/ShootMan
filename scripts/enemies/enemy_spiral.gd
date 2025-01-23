extends EnemyStandard
class_name EnemySpiral 

var spiral : float


func _move_and_rotate(delta, target):
	spiral += delta / 10 	# a time-dependent var to make spiral
	if world == null:
		print("Error: EnemySpiral.world not assigned - has .enemy_setup() run?")
	
	var player_pos = target
	var distance_to_player = global_position.distance_to(player_pos)
	
	var bearing = player_pos + Vector2(cos(spiral), sin(spiral)) * distance_to_player / spiral
	movement_component.move_and_rotate(movement_resource, bearing, delta)
