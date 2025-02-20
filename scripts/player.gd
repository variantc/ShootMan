extends CharacterBody2D
class_name Player


@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float


@onready var shoot_component = %ShootComponent as ShootComponent
@onready var movement_component = %MovementComponent as MovementComponent
@onready var movement_resource : MovementResource
@onready var sprite := %Sprite2D

var counter := 0.0

var start_pos : Vector2


func _ready():
	Refs.register_node(self)
	start_pos = global_position
	
	movement_resource = MovementResource.new(self, speed, ang_acc)


func _physics_process(delta):
	# Movement component now returns KinematicCollision2D since we're using
	# move_and_collide.  This will move and check
	_check_collision(_move_and_rotate(delta))
	
	var direction = Vector2.RIGHT.rotated(global_rotation)
	%ShootComponent.shoot(delta, direction)
	
	
func _move_and_rotate(delta) -> KinematicCollision2D:
	# Reverse on RMB
	movement_resource.reverse = false
	if Input.is_action_pressed("RMB"):
		movement_resource.reverse = true
		
	return movement_component.move_and_rotate(movement_resource, get_global_mouse_position(), delta)
	
	
func _check_collision(collision : KinematicCollision2D):
	if collision:
		SignalBus.player_killed.emit()
		
		
func modulate_sprite(amount : float) -> void:
	if amount != 0:
		sprite.modulate = Color(amount,0,0,1)
	else:
		sprite.modulate = Color.WHITE
