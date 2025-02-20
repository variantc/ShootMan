extends Node2D
class_name DebugDraw


func _ready() -> void:
	# Ensure this is drawn on top of other nodes
	z_index = 100

	
func _process(_delta: float) -> void:
	# Constantly update the visualization
	queue_redraw()
	
	# Clean up expired temporary debug items
	var current_time = Time.get_ticks_msec()
	for id in Refs.debug_lines.keys():
		var line = Refs.debug_lines[id]
		if line.time > 0 and current_time - line.created > line.time * 1000:
			Refs.debug_lines.erase(id)
			
	for id in Refs.debug_points.keys():
		var point = Refs.debug_points[id]
		if point.time > 0 and current_time - point.created > point.time * 1000:
			Refs.debug_points.erase(id)
	
	
func _draw() -> void:
	if not Refs.world.DEBUG:
		return
		
	# Draw all registered debug lines
	for id in Refs.debug_lines:
		var line = Refs.debug_lines[id]
		draw_line(to_local(line.start), to_local(line.end), line.color, line.width)
	
	# Draw all registered debug points
	for id in Refs.debug_points:
		var point = Refs.debug_points[id]
		draw_circle(to_local(point.position), point.radius, point.color)
