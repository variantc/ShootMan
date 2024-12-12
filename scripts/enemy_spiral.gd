extends EnemyStandard
class_name EnemySpiral 

var spiral : float

func _move_and_rotate(delta):
	spiral += delta / 10 	# a time-dependent var to make spiral
	if world == null:
		print("Error: EnemySpiral.world not assigned - has .enemy_setup() run?")
	
	var player_pos = world.player.global_position
	var distance_to_player = global_position.distance_to(player_pos)
	
	movement_component.move_and_rotate(
		delta, 
		self, 
		#player_pos + Vector2.RIGHT.rotated(spiral) * distance_to_player,
		player_pos + Vector2(cos(spiral), sin(spiral)) * distance_to_player / spiral,
		speed,
		ang_acc)
