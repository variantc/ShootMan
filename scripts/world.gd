extends Node2D
class_name World


@onready var sound_manager := $SoundManager as SoundManager
@onready var player := $Player as Player
@onready var enemy_spawner := $EnemySpawner as EnemySpawner
@onready var score_text := $ScoreText as RichTextLabel

var enemy_list : Array[EnemyStandard]


func _ready():
	enemy_spawner.enemy_spawned.connect(_register_enemy)

func _register_enemy(enemy : EnemyStandard):
	enemy_list.append(enemy)
	enemy.enemy_killed.connect(_enemy_killed)
	

func _enemy_killed(enemy, audio):
	enemy_list.remove_at(enemy_list.find(enemy))
	sound_manager.play_sound(audio.stream)
	score_text.update_points_by(1)
