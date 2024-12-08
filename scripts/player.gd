extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var shot_speed : float
@export var shot_strength : float
@export var shot_time : float

@onready var movement_component = $MovementComponent as MovementComponent

var counter := 0.0

func _ready():
	pass


func _process(delta):
	_move_and_rotate(delta)
	_check_collision()
	_shoot(shot_speed, shot_strength, delta)
	
	
func _shoot(spd, strength, delta):
	counter += delta
	if counter > shot_time:
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.setup(global_position, rotation, spd, strength, 3)
		
		world.add_child(bullet)
		counter = 0.0
	
	
func _move_and_rotate(delta):
	# Reverse on RMB
	var rev = false
	if Input.is_action_pressed("RMB"):
		rev = true
		
	movement_component.move_and_rotate(
		delta, 
		self, 
		get_global_mouse_position(),
		speed,
		ang_acc,
		rev)
	
func _check_collision():
	var collision = get_last_slide_collision() as KinematicCollision2D
	if collision:
		print("KILL PLAYER, GAME OVER")
