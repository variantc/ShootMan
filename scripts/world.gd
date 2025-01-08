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
	print(get_tree().root.get_child_count())


func _on_enemy_killed(enemy, audio):
	sound_manager.play_sound(audio.stream)
	drop_spawner.spawn_drop(enemy.global_position)


func _on_drop_pickedup(audio : AudioStreamPlayer2D):
	sound_manager.play_sound(audio.stream)
	score_text.score += 1


func _on_drop_to_player(drop : DropStandard):
	drop_spawner.set_player_for_drop(drop, player)

	
#var counter = 0
#func _process(delta):
	#counter += delta
	#if counter > 2:
		#counter = 0
		#player.current_gun.shot_number += 1
		#player.current_gun.shot_spread += 10
