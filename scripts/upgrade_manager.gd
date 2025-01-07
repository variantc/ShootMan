extends Node
class_name UpgradeManager


static var Type = {
	SHOT_NUMBER = 0,
	SHOT_TIME = 1,
	SHOT_SPREAD = 2,
	SHOT_LIFETIME = 3
}

static var Operation = {
	ADD = 0,
	MULTIPLY = 1
}

static var UPGRADE_VALUES = {
	Type.SHOT_NUMBER: {"amount": 1.0, "operation": Operation.ADD},
	Type.SHOT_TIME: {"amount": -0.05, "operation": Operation.ADD},
	Type.SHOT_SPREAD: {"amount": 10.0, "operation": Operation.ADD},
	Type.SHOT_LIFETIME: {"amount": 0.25, "operation": Operation.ADD}
}

@export var score_text: ScoreText
@export var upgrade_cost := 0

func _ready():
	SignalBus.upgrade_button_pressed.connect(_on_upgrade_button_pressed)


func _on_upgrade_button_pressed(upgrade_type: int):
	if score_text.score >= upgrade_cost:
		score_text.score -= upgrade_cost
		var upgrade_info = UPGRADE_VALUES[upgrade_type]
		print(upgrade_info)
		SignalBus.apply_upgrade.emit(
			upgrade_type, 
			upgrade_info.amount,
			upgrade_info.operation
		)
