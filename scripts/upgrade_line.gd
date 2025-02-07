extends Line2D


var timer := 0.0
var direction := 1

# Called when the node enters the scene tree for the first time.
#func _ready():
	#var _node_line_tween = create_tween() as Tween
	#
	#_node_line_tween.tween_method(set_first_point_colour, Color.BLACK, Color.BLUE, 1.0)\
		#.set_ease(Tween.EASE_OUT)\
		#.set_trans(Tween.TRANS_QUAD)



func set_first_point_colour(colour : Color):
	gradient.set_color(0, colour)


func _physics_process(delta):
	timer += direction * delta
	if timer >= 1.0 or timer <= -1.0:
		direction = -direction
	gradient.set_color(0, abs(timer) * Color(1,0,0,0))
	gradient.set_color(1, abs(timer) * Color(1,0,0,1))
