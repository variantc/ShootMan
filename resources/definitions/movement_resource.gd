extends Resource
class_name MovementResource


var body: CharacterBody2D
var speed: float
var ang_acc: float
var reverse: bool = false

var initial_values : Dictionary


func _init(init_body, init_speed, init_ang_acc, init_reverse = false):
	body = init_body
	speed = init_speed
	ang_acc = init_ang_acc
	reverse = init_reverse


func _store_initial_values() -> void:
	initial_values = {
		UpgradeManager.Type.PLAYER_SPEED : speed,
		UpgradeManager.Type.PLAYER_ANG_ACC : ang_acc
	}


func apply_upgrade(upgrade_type : UpgradeManager.Type, level : int) -> void:
	# Ensure initial values are stored
	if initial_values.is_empty():
		_store_initial_values()
		
	match upgrade_type:
		UpgradeManager.Type.PLAYER_SPEED:
			speed = initial_values[UpgradeManager.Type.PLAYER_SPEED] + level * 10
			print_debug("adding speed: " + str(speed))
		UpgradeManager.Type.PLAYER_ANG_ACC:
			ang_acc = initial_values[UpgradeManager.Type.PLAYER_ANG_ACC] + level * 0.1
			print_debug("adding ang_acc: " + str(ang_acc))
