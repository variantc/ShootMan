extends CharacterBody2D
class_name EnemyStandard


@export var speed : float
@export var ang_acc : float
@export var health : float

var player : Player
var sound_manager : SoundManager


func _ready():
	player = get_tree().root.get_child(0).find_child('Player')
	if player == null:
		print("ERROR: No Player found")
	sound_manager = get_tree().root.get_child(0).find_child('SoundManager')
	if sound_manager == null:
		print("ERROR: No SoundManager found")


func _process(delta):
	_move_and_rotate(delta)

	
func _move_and_rotate(delta):
	var player_pos = player.global_position
	var target_angle = get_angle_to(player_pos)

	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	rotation += rotate_amount

	velocity = (player_pos - global_position).normalized() * speed
	move_and_slide()
	

func hit(bullet : Bullet):
	var bullet_damage = health
	health -= bullet.strength
	bullet.strength -= bullet_damage
	if health <= 0:
		die()
	

func die():
		# Play death sound which will signal queue_free on finished
		sound_manager.play_sound(%AudioStreamPlayer2D.stream)
		var score_text = get_tree().root.get_child(0).find_child('ScoreText')
		if score_text == null:
			print("ERROR: EnemyStandard cannot find 'ScoreText' in world")
		score_text.update_points_by(1)
		queue_free()


func _on_audio_stream_player_2d_finished():
	self.queue_free()
