extends Line2D
class_name UpgradeLine

var timer := -0.5
const POINT_SPACING := 5.0  # Distance between points


func _physics_process(delta):
	timer += delta
	if timer >= 1.5:
		timer -= 2.0

	
	if timer < 0 or timer > 1.0:
		width_curve.set_point_value(1, 0.2)
		width_curve.set_point_value(2, 0.2)
		width_curve.set_point_left_tangent(1, 0)
		width_curve.set_point_left_tangent(2, 0)
		width_curve.set_point_right_tangent(1, 0)
		width_curve.set_point_right_tangent(2, 0)
		
	else:
		width_curve.set_point_value(1, 1)
		width_curve.set_point_value(2, 1)
		width_curve.set_point_left_tangent(1, 5)
		width_curve.set_point_left_tangent(2, -5)
		width_curve.set_point_right_tangent(1, 5)
		width_curve.set_point_right_tangent(2, -5)
		
	width_curve.set_point_offset(1, timer-0.05)
	width_curve.set_point_offset(2, min(timer+0.05,1))


func set_endpoint(end_point: Vector2):
	points[1] = end_point
	create_intermediate_points()


func create_intermediate_points():
	var start_point := points[0]
	var end_point := points[1]
	var direction := (end_point - start_point).normalized()
	var distance := start_point.distance_to(end_point)
	
	# Clear existing points but keep start and end
	var new_points := PackedVector2Array([start_point])
	
	# Create points at regular intervals
	var current_distance := POINT_SPACING
	while current_distance < distance:
		var point := start_point + direction * current_distance
		new_points.append(point)
		current_distance += POINT_SPACING
	
	# Add end point
	new_points.append(end_point)
	points = new_points
