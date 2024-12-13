extends Area2D
class_name DropStandard

signal drop_picked_up(audio : AudioStreamPlayer2D)

@export var pickup_radius : int

var move_to_player := false
var pickup_speed = 2

var player : Player

func _ready():
	%CollisionShape2D.shape.radius = pickup_radius
	player = get_parent().world.player as Player


func _process(delta):
	if move_to_player:
		print("here")
		global_position += global_position.direction_to(player.global_position).normalized() * pickup_speed
		if global_position.distance_squared_to(player.global_position) < 1:
			picked_up()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		move_to_player = true
	
	
func picked_up():
	drop_picked_up.emit(%AudioStreamPlayer2D)
	queue_free()
