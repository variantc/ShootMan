extends Node
class_name MovementComponent


var stop : bool = false

func move_and_rotate(
		delta, 
		body: CharacterBody2D, 
		target: Vector2, 
		speed: float, 
		ang_acc: float,
		reverse: bool = false): #-> KinematicCollision2D:

	if stop:
		body.velocity = Vector2.ZERO
		return
		
	if speed < 0.001:
		print_debug(body.name + ": has zero speed, is this intentional?")
			
	# Calculate the rotation
	var target_angle = body.get_angle_to(target)
	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	body.rotation += rotate_amount

	# Velocity based on rotation
	var direction = Vector2.RIGHT.rotated(body.rotation)
	var factor = -1 if reverse else 1
	body.velocity = factor * direction * speed
	
	body.move_and_collide(body.velocity * delta)
