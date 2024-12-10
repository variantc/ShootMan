extends CharacterBody2D
class_name EnemyStandard


signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)

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
	

func enemy_setup(world: World, position):
	self.world = world
	global_position = position


func hit(bullet : Bullet):
	var bullet_damage = health
	health -= bullet.strength
	bullet.strength -= bullet_damage
	if health <= 0:
		die()
	

func die():
		enemy_killed.emit(self, %AudioStreamPlayer2D)
		queue_free()
