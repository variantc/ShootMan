extends Node


@export var score_text : ScoreText
@export var upgrade_cost := 1


# Define upgrade properties
const UPGRADE_VALUES = {
	"shot_number": {"amount": 1.0, "type": "add"},
	"shot_time": {"amount": -0.05, "type": "add"},
	"shot_spread": {"amount": 10.0, "type": "add"},
	"shot_lifetime": {"amount": 0.25, "type": "add"}
}

func _ready():
	SignalBus.upgrade_button_pressed.connect(_on_upgrade_button_pressed)

func _on_upgrade_button_pressed(upgrade_type: String):
	if score_text.score >= upgrade_cost:
		score_text.score -= upgrade_cost
		SignalBus.apply_upgrade.emit(
			upgrade_type, 
			UPGRADE_VALUES[upgrade_type]["amount"]
		)
