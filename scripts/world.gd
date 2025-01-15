extends Node2D
class_name World


@onready var sound_manager := $SoundManager as SoundManager
@onready var player := $Player as Player
@onready var drop_spawner := $DropSpawner as DropSpawner
@onready var enemy_spawner := $EnemySpawner as EnemySpawner
@onready var score_text := %ScoreText as RichTextLabel

var offset_to_player : Vector2


func _ready():
	SignalBus.drop_to_player.connect(_on_drop_to_player)
	SignalBus.drop_picked_up.connect(_on_drop_pickedup)
	SignalBus.enemy_killed.connect(_on_enemy_killed)


func _on_enemy_killed(enemy, audio):
	sound_manager.play_sound(audio.stream)
	
	# we want to check if the enemy has just been killed so that we don't
	# spawn multiple drops for an enemy shot by two bullets at once
	if enemy in enemy_spawner.enemy_list:
		enemy_spawner.remove_enemy_from_list(enemy)
		drop_spawner.spawn_drop(enemy.global_position)
	else:
		print_debug("enemy not in enemy list?")


func _on_drop_pickedup(audio : AudioStreamPlayer2D):
	sound_manager.play_sound(audio.stream)
	score_text.score += 1


func _on_drop_to_player(drop : DropStandard):
	drop_spawner.set_player_for_drop(drop, player)
