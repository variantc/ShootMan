extends Node
class_name MovementComponent


func move_and_rotate(delta, 
		body: CharacterBody2D, 
		target: Vector2, 
		speed: float, 
		ang_acc: float,
		reverse: bool = false):
			
	var target_angle = body.get_angle_to(target)

	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	body.rotation += rotate_amount

	var factor = 1
	if reverse:
		factor = -1
	body.velocity = factor * (target - body.global_position).normalized() * speed
	body.move_and_slide()
	
#func _move_and_rotate(delta, target: Vector2):
	#var mouse_pos = get_global_mouse_position()
	#var target_angle = get_angle_to(mouse_pos)
#
	## Limit the rotation based on ang_acc
	#var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	#rotation += rotate_amount
#
	#velocity = (mouse_pos - global_position).normalized() * speed
	#
	## Reverse on RMB
	#if Input.is_action_pressed("RMB"):
		#velocity = -1.0 * velocity
	#move_and_slide()
	#var collision = get_last_slide_collision() as KinematicCollision2D
	#if collision:
		#print("KILL PLAYER, GAME OVER")
