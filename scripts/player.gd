extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var shot_speed : float
@export var shot_strength : float
@export var shot_time : float
@export var shot_number : int
@export var shot_spread : float
@export var bullet_scale : float
@export var scatter : int
@export var repeat_scatter : bool

@onready var movement_component = $MovementComponent as MovementComponent

var counter := 0.0

func _ready():
	pass


func _process(delta):
	_move_and_rotate(delta)
	_check_collision()
	_shoot(
		shot_speed, 
		shot_strength, 
		delta, 
		shot_number, 
		shot_spread, 
		bullet_scale
	)
	
	
func _shoot(spd, strength, delta, number=1, spread=0.0, bul_scale=1.0):
	counter += delta
	var rad_spread = spread * PI/180
	if counter > shot_time:
		counter = 0.0
		for i in range(number):
			var rot = rotation
			if number != 1:
				rot = rotation - (rad_spread)/2 + (i * rad_spread)/number
			var bullet = bullet_scene.instantiate() as Bullet
			world.add_child(bullet)
			bullet.setup(
				global_position, 
				rot, 
				spd, 
				strength, 
				scatter,
				repeat_scatter,
				bul_scale)
			
	
	
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
