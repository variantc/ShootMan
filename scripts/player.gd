extends CharacterBody2D
class_name Player


@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var shot_speed : float
@export var shot_strength : float
@export var shot_time : float
var counter := 0.0

func _ready():
	pass


func _process(delta):
	_move_and_rotate(delta)
	_shoot(shot_speed, shot_strength, delta)

	
func _shoot(spd, strength, delta):
	counter += delta
	if counter > shot_time:
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.setup(global_position, rotation, spd, strength, 3)
		
		get_tree().root.add_child(bullet)
		counter = 0.0
	
	
func _move_and_rotate(delta):
	var mouse_pos = get_global_mouse_position()
	var target_angle = get_angle_to(mouse_pos)

	# Limit the rotation based on ang_acc
	var rotate_amount = clamp(target_angle, -ang_acc * delta, ang_acc * delta)
	rotation += rotate_amount

	velocity = (mouse_pos - global_position).normalized() * speed
	
	# Reverse on RMB
	if Input.is_action_pressed("RMB"):
		velocity = -1.0 * velocity
	move_and_slide()
	var collision = get_last_slide_collision() as KinematicCollision2D
	if collision:
		print("KILL PLAYER, GAME OVER")
