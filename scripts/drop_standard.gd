extends Area2D
class_name DropStandard

signal drop_picked_up(audio : AudioStreamPlayer2D)

@onready var world : World

@export var pickup_radius : int


func _ready():
	%CollisionShape2D.shape.radius = pickup_radius


func _on_body_entered(body):
	if body.is_in_group("Player"):
		drop_picked_up.emit(%AudioStreamPlayer2D)
		queue_free()
