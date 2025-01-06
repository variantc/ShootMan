extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var current_gun : GunResource

@onready var movement_component = $MovementComponent as MovementComponent

var counter := 0.0

func _ready():
	SignalBus.change_shot_number.connect(_on_change_shot_number)
	SignalBus.change_shot_spread.connect(_on_change_shot_spread)


func _on_change_shot_number(amt : int):
	current_gun.shot_number += amt
	current_gun.shot_spread += 5
	

func _on_change_shot_spread(amt : float):
	current_gun.shot_spread += amt
	

func _process(delta):
	_move_and_rotate(delta)
	_check_collision()
	_shoot(delta, current_gun)
	
	
func _shoot(delta, gun_resource : GunResource):
	if gun_resource.shot_number == 0:
		print("ERROR: Shot number is zero!")
		return
		
	counter += delta
	var rad_spread = gun_resource.shot_spread * PI/180
	if counter > gun_resource.shot_time:
		counter = 0.0
		for i in range(gun_resource.shot_number):
			var rot = global_rotation
			if gun_resource.shot_number > 1:
				rot = global_rotation - (rad_spread)/2 + i * rad_spread/(gun_resource.shot_number-1)
			var bullet = bullet_scene.instantiate() as Bullet
			world.add_child(bullet)
			
			#var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			var bullet_stats = gun_resource.current_bullet
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
