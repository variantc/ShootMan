extends CharacterBody2D
class_name EnemyStandard


@export var speed : float
@export var ang_acc : float
@export var health : float

@onready var movement_component = $MovementComponent as MovementComponent

var world : World


func _process(delta):
	_move_and_rotate(delta)
	
	
func _move_and_rotate(delta):
	if world == null:
		print("Error: EnemyStandard.world not assigned - has .enemy_setup() run?")
	
	movement_component.move_and_rotate(
		delta, 
		self, 
		world.player.global_position,
		speed,
		ang_acc)
	

func enemy_setup(game_world: World, pos : Vector2):
	self.world = game_world
	global_position = pos


func hit(bullet : Bullet, bullet_direction : Vector2, bullet_speed : float):
	_knock_back(bullet_direction, bullet_speed)
	
	var bullet_damage = health
	health -= bullet.strength
	bullet.strength -= bullet_damage
	if health <= 0:
		die()
	
	
func _knock_back(direction: Vector2, speed: float):
	var kb_red_factor = 0.075
	var kb_time = 0.3
	var tween = create_tween()
	var kb_target_pos = global_position + direction * speed * kb_red_factor
	
	# Moves from current position to target position over 0.3 seconds
	tween.tween_property(self, "global_position", kb_target_pos, kb_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)
		

func die():
		SignalBus.enemy_killed.emit(self, %AudioStreamPlayer2D)
		queue_free()
