extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var current_gun : GunResource

@onready var movement_component = %MovementComponent as MovementComponent

var counter := 0.0

var start_pos : Vector2

func _ready():
	SignalBus.apply_upgrade.connect(_on_apply_upgrade)
	
	start_pos = global_position


func _on_apply_upgrade(upgrade_type: int, amount, operation: int):
	match upgrade_type:
		UpgradeManager.Type.SHOT_NUMBER:
			current_gun.shot_number += amount
			current_gun.shot_spread += 5
		UpgradeManager.Type.SHOT_TIME:
			current_gun.shot_time += amount
		UpgradeManager.Type.SHOT_SPREAD:
			current_gun.shot_spread += amount
		UpgradeManager.Type.SHOT_LIFETIME:
			current_gun.current_bullet.lifetime += amount
	

func _process(delta):
	_move_and_rotate(delta)
	_check_collision()
	%ShootComponent.shoot(delta, current_gun)
	
	
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
		SignalBus.player_killed.emit()
