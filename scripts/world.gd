extends Node2D
class_name World


@onready var sound_manager := $SoundManager as SoundManager
@onready var player := $Player as Player
@onready var drop_spawner := $DropSpawner as DropSpawner
@onready var enemy_spawner := $EnemySpawner as EnemySpawner
@onready var score_text := $ScoreText as RichTextLabel

var enemy_list : Array[EnemyStandard]


func _ready():
	enemy_spawner.enemy_spawned.connect(_register_enemy)
	drop_spawner.drop_picked_up.connect(_on_drop_pickedup)
	drop_spawner.spawn_drop(Vector2(400,400))


func _register_enemy(enemy : EnemyStandard):
	enemy_list.append(enemy)
	enemy.enemy_killed.connect(_enemy_killed)
	

func _enemy_killed(enemy, audio):
	enemy_list.remove_at(enemy_list.find(enemy))
	sound_manager.play_sound(audio.stream)
	drop_spawner.spawn_drop(enemy.global_position)


func _on_drop_pickedup():
	score_text.update_points_by(1)
