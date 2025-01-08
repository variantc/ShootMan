extends Camera2D


@export var player : Player
@export var lag : int = 10000


func _ready():
	global_position = player.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	# Smoothing of camera movement
	var offset_sq = global_position.distance_squared_to(player.global_position)
	global_position = lerp(global_position, player.global_position, delta * offset_sq / lag)
		
