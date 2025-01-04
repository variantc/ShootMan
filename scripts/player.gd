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
	if number == 0:
		print("ERROR: Shot number is zero!")
		return
		
	counter += delta
	var rad_spread = spread * PI/180
	if counter > shot_time:
		counter = 0.0
		for i in range(number):
			var rot = global_rotation
			if number > 1:
				rot = global_rotation - (rad_spread)/2 + i * rad_spread/(number-1)
			var bullet = bullet_scene.instantiate() as Bullet
			world.add_child(bullet)
			
			var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			
			bullet_stats.bullet_position = global_position
			bullet_stats.rotation = rot
			bullet_stats.speed = spd
			bullet_stats.strength = strength
			bullet_stats.scatter = scatter
			bullet_stats.repeat_scatter = repeat_scatter
			bullet_stats.scale = bul_scale
			
			bullet.setup(bullet_stats)
			
	
	
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
