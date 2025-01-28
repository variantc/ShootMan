extends Resource
class_name WeaponResource


enum Type { BULLET, MISSILE }
enum UpgradeType { SHOT_NUMBER, SHOT_TIME, SHOT_SPREAD, SHOT_LIFETIME }

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
		UpgradeType.SHOT_NUMBER : shot_number,
		UpgradeType.SHOT_TIME : shot_time,
		UpgradeType.SHOT_SPREAD : shot_spread,
		UpgradeType.SHOT_LIFETIME : lifetime
	}
	
	
func apply_upgrade(upgrade_type : UpgradeType, level : int) -> void:
	# Ensure initial values are stored
	if initial_values.is_empty():
		_store_initial_values()
		
	print_debug(shot_time)
	match upgrade_type:
		UpgradeType.SHOT_NUMBER:
			shot_number = level + 1
			shot_spread = level + 1
		UpgradeType.SHOT_TIME:
			shot_time = initial_values[UpgradeType.SHOT_TIME] - level * 0.05
		UpgradeType.SHOT_SPREAD:
			shot_spread = initial_values[UpgradeType.SHOT_SPREAD] * level
		UpgradeType.SHOT_LIFETIME:
			lifetime = level


func reset_upgrades() -> void:
	if not initial_values.is_empty():
		shot_number = initial_values[UpgradeType.SHOT_TIME]
		shot_time = initial_values[UpgradeType.SHOT_NUMBER]
		shot_spread = initial_values[UpgradeType.SHOT_SPREAD]
		lifetime = initial_values[UpgradeType.SHOT_LIFETIME]
