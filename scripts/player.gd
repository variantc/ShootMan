extends CharacterBody2D
class_name Player

@onready var world = get_parent() as World

@export var bullet_scene : PackedScene
@export var speed : float
@export var ang_acc : float

@export var start_weapon : WeaponResource
var current_weapon : WeaponResource

@onready var movement_component = %MovementComponent as MovementComponent
@onready var movement_resource : MovementResource

var counter := 0.0

var start_pos : Vector2


func _ready():
	#SignalBus.apply_upgrade.connect(_on_apply_upgrade)
	SignalBus.upgrade_value_changed.connect(_on_upgrade_value_changed)
	SignalBus.debug_upgrade_button_pressed.connect(_on_debug_upgrade)
	start_pos = global_position
	
	movement_resource = MovementResource.new(self, speed, ang_acc)
	current_weapon = start_weapon.duplicate()
	

func _on_debug_upgrade(upgrade_type: int):
	match upgrade_type:
		UpgradeManager.Type.SHOT_NUMBER:
			current_weapon.shot_number += 1
			current_weapon.shot_spread += 1
		UpgradeManager.Type.SHOT_TIME:
			print_debug("before " + str(current_weapon.shot_time))
			current_weapon.shot_time -= 0.05
			print_debug("after " + str(current_weapon.shot_time))
		UpgradeManager.Type.SHOT_SPREAD:
			current_weapon.shot_spread += 2.5
		UpgradeManager.Type.SHOT_LIFETIME:
			current_weapon.current_bullet.lifetime += 0.05
	
	
func _on_upgrade_value_changed(upgrade_type: int, level : int, _operation : int = 0):
	var max_level = 0
	for n in world.claimed_upgrade_nodes:
		print_debug(n.level)
		max_level = max(n.level, max_level)
	
	match upgrade_type:
		UpgradeManager.Type.SHOT_NUMBER:
			current_weapon.shot_number = max_level + 1
			current_weapon.shot_spread = (max_level + 1)
		UpgradeManager.Type.SHOT_TIME:
			print_debug("before " + str(current_weapon.shot_time))
			current_weapon.shot_time = start_weapon.shot_time - max_level * 0.05
			print_debug("after " + str(current_weapon.shot_time))
		UpgradeManager.Type.SHOT_SPREAD:
			current_weapon.shot_spread *= max_level
		UpgradeManager.Type.SHOT_LIFETIME:
			current_weapon.lifetime = max_level
	

func _physics_process(delta):
	# Movement component now returns KinematicCollision2D since we're using
	# move_and_collide.  This will move and check
	_check_collision(_move_and_rotate(delta))
	
	%ShootComponent.shoot(delta, current_weapon)
	
	
func _move_and_rotate(delta) -> KinematicCollision2D:
	# Reverse on RMB
	movement_resource.reverse = false
	if Input.is_action_pressed("RMB"):
		movement_resource.reverse = true
		
	return movement_component.move_and_rotate(movement_resource, get_global_mouse_position(), delta)
	
	
func _check_collision(collision : KinematicCollision2D):
	if collision:
		SignalBus.player_killed.emit()
