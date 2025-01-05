extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float


@export var shot_time : float
@export var shot_number : int
@export var shot_spread : float

@export var current_bullet : BulletResource

@onready var movement_component = $MovementComponent as MovementComponent

var counter := 0.0

func _ready():
	pass


func _process(delta):
	_move_and_rotate(delta)
	_check_collision()
	_shoot(delta, shot_number, shot_spread, current_bullet)
	
	
func _shoot(delta, number, spread, bullet_resource : BulletResource):
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
			
			#var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			var bullet_stats = bullet_resource.duplicate() as BulletResource
			bullet_stats.bullet_position = global_position
			bullet_stats.rotation = rot
			
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
