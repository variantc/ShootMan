extends Node2D
class_name World


@onready var sound_manager := $SoundManager as SoundManager
@onready var player := $Player as Player
@onready var drop_spawner := $DropSpawner as DropSpawner
@onready var enemy_spawner := $EnemySpawner as EnemySpawner
@onready var score_text := $ScoreText as RichTextLabel

func _ready():
	drop_spawner.drop_picked_up.connect(_on_drop_pickedup)
	enemy_spawner.enemy_killed.connect(_on_enemy_killed)
	

func _on_enemy_killed(enemy, audio):
	sound_manager.play_sound(audio.stream)
	drop_spawner.spawn_drop(enemy.global_position)


func _on_drop_pickedup():
	score_text.update_points_by(1)
