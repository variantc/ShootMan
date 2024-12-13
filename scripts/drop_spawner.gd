extends Node
class_name DropSpawner

signal drop_to_player(drop : DropStandard)
signal drop_picked_up(audio : AudioStreamPlayer2D)

@export var drop_scene : PackedScene


func spawn_drop(position : Vector2):
	var drop = drop_scene.instantiate() as DropStandard
	drop.drop_picked_up.connect(_on_drop_picked_up)
	drop.drop_to_player.connect(_on_drop_to_player)
	add_child(drop)
	drop.global_position = position


func _on_drop_picked_up(audio : AudioStreamPlayer2D):
	drop_picked_up.emit(audio)


func _on_drop_to_player(drop : DropStandard):
	drop_to_player.emit(drop)


func set_player_for_drop(drop : DropStandard, player : Player):
	drop.player = player
