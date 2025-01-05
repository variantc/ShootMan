extends Area2D
class_name DropStandard


@export var pickup_radius : int
@export var pickup_speed = 2


var player : Player = null

func _ready():
	%CollisionShape2D.shape.radius = pickup_radius


func _process(_delta):
	if player:
		_move_to_player()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		SignalBus.drop_to_player.emit(self)


func _move_to_player():
		global_position += global_position.direction_to(player.global_position).normalized() * pickup_speed
		if global_position.distance_squared_to(player.global_position) < 1:
			picked_up()
		
	
func picked_up():
	SignalBus.drop_picked_up.emit(%AudioStreamPlayer2D)
	queue_free()
