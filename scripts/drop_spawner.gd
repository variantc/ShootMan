extends Node
class_name DropSpawner


@export var drop_scene : PackedScene


func spawn_drop(position : Vector2):
	var drop = drop_scene.instantiate() as DropStandard
	call_deferred("add_child", drop)
	drop.global_position = position


func set_player_for_drop(drop : DropStandard, player : Player):
	drop.player = player
