extends Resource
class_name WeaponResource


enum Type { BULLET, MISSILE }
#enum UpgradeType { SHOT_NUMBER, SHOT_TIME, SHOT_SPREAD, SHOT_LIFETIME }

@export var id : String
@export var shot_time : float = 1 :
	set(value):
		shot_time = max(0.05, value)
@export var shot_number : int = 1 :
	set(value):
		shot_number = value
@export var shot_spread : float = 2.5
@export var projectile_type : WeaponResource.Type

@export var speed : float
@export var angular_acc : float = 0
@export var strength : float
@export var scatter : int = 0
@export var repeat_scatter : bool = false
@export var scale : float = 1.0
@export var lifetime : float
@export var mask: int

var projectile_position : Vector2 
var rotation : float 

var initial_values : Dictionary


func _store_initial_values() -> void:
	initial_values = {
		UpgradeManager.Type.SHOT_NUMBER : shot_number,
		UpgradeManager.Type.SHOT_TIME : shot_time,
		UpgradeManager.Type.SHOT_SPREAD : shot_spread,
		UpgradeManager.Type.SHOT_LIFETIME : lifetime,
		UpgradeManager.Type.SHOT_SPEED : speed
	}
	
	
func apply_upgrade(upgrade_type : UpgradeManager.Type, level : int) -> void:
	# Ensure initial values are stored
	if initial_values.is_empty():
		_store_initial_values()
		
	match upgrade_type:
		UpgradeManager.Type.SHOT_NUMBER:
			shot_number = initial_values[UpgradeManager.Type.SHOT_NUMBER] + level + 1
			#shot_spread = level + 1
			print_debug("adding shots: " + str(shot_number))
		UpgradeManager.Type.SHOT_TIME:
			shot_time = initial_values[UpgradeManager.Type.SHOT_TIME] - level * 0.05
		UpgradeManager.Type.SHOT_SPREAD:
			shot_spread = initial_values[UpgradeManager.Type.SHOT_SPREAD] * level
		UpgradeManager.Type.SHOT_LIFETIME:
			lifetime = initial_values[UpgradeManager.Type.SHOT_LIFETIME] + level * 0.1
		UpgradeManager.Type.SHOT_SPEED:
			speed = initial_values[UpgradeManager.Type.SHOT_SPEED] + level * 50
			print_debug("adding shotspeed: " + str(speed))


func reset_upgrades() -> void:
	if not initial_values.is_empty():
		shot_number = initial_values[UpgradeManager.Type.SHOT_NUMBER]
		shot_time = initial_values[UpgradeManager.Type.SHOT_TIME]
		shot_spread = initial_values[UpgradeManager.Type.SHOT_SPREAD]
		lifetime = initial_values[UpgradeManager.Type.SHOT_LIFETIME]
		speed = initial_values[UpgradeManager.Type.SHOT_SPEED]
