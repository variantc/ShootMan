extends EnemyStandard
class_name EnemySpiral 

var spiral : float


func _move_and_rotate(delta, target_pos):
	spiral += delta / 10 	# a time-dependent var to make spiral
	
	var distance_to_target = global_position.distance_to(target_pos)
	
	var bearing = target_pos + Vector2(cos(spiral), sin(spiral)) * distance_to_target / spiral
	movement_component.move_and_rotate(movement_resource, bearing, delta)
