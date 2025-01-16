extends Node
class_name MovementComponent


func move_and_rotate(
		delta, 
		body: CharacterBody2D, 
		target: Vector2, 
		speed: float, 
		ang_acc: float,
		reverse: bool = false):

	if speed < 0.001:
		print_debug(body.name + ": has zero speed, is this intentional?")
			
	var target_angle = body.get_angle_to(target)

	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	body.rotation += rotate_amount

	var direction = Vector2.RIGHT.rotated(body.rotation)
	var factor = -1 if reverse else 1

	#body.velocity = factor * (target - body.global_position).normalized() * speed
	body.velocity = factor * direction * speed
	
	body.move_and_slide()
