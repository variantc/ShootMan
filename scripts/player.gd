extends CharacterBody2D
class_name Player


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
	Refs.register_player(self)
	
	SignalBus.upgrade_value_changed.connect(_on_upgrade_value_changed)
	SignalBus.debug_upgrade_button_pressed.connect(_on_debug_upgrade)
	start_pos = global_position
	
	movement_resource = MovementResource.new(self, speed, ang_acc)
	current_weapon = start_weapon.duplicate()
	

func _on_debug_upgrade(upgrade_type: int):
	printerr("Debug upgrades not currently implemented")
	#current_weapon.apply_upgrade(upgrade_type)
	
	
func _on_upgrade_value_changed(upgrade_type: int, level : int, _operation : int = 0):
	var max_level = 0
	for n in Refs.world.claimed_upgrade_nodes:
		var node = n as UpgradeNode
		if upgrade_type == node.upgrade_type:
			max_level = max(node.level, max_level)
	
	current_weapon.apply_upgrade(upgrade_type, max_level)
	

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
