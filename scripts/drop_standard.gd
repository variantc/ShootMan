extends Area2D
class_name DropStandard

signal drop_picked_up

@onready var world : World


func _ready():
	world = get_tree().root.get_child(0)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		drop_picked_up.emit()
		queue_free()
