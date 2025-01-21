extends Node
class_name MovementComponent


var stop : bool = false

func move_and_rotate(movement_resource : MovementResource, target : Vector2, delta : float) -> KinematicCollision2D:

	if stop:
		movement_resource.body.velocity = Vector2.ZERO
		return
		
	if movement_resource.speed < 0.001:
		print_debug(movement_resource.body.name + ": has zero speed, is this intentional?")
			
	# Calculate the rotation
	var target_angle = movement_resource.body.get_angle_to(target)
	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -movement_resource.ang_acc * delta, movement_resource.ang_acc * delta)
	movement_resource.body.rotation += rotate_amount

	# Velocity based on rotation
	var direction = Vector2.RIGHT.rotated(movement_resource.body.rotation)
	var factor = -1 if movement_resource.reverse else 1
	movement_resource.body.velocity = factor * direction * movement_resource.speed
	
	return movement_resource.body.move_and_collide(movement_resource.body.velocity * delta)
