extends Node
class_name UpgradeManager


enum Type {
	SHOT_NUMBER,
	SHOT_TIME,
	SHOT_SPREAD,
	SHOT_LIFETIME,
	RANDOM
}


static var Operation = { 	# NOT YET USED
	ADD = 0,
	MULTIPLY = 1
}


static var UPGRADE_NAMES = { 
	Type.SHOT_NUMBER: "+ Shot Number",
	Type.SHOT_TIME: "- Reduce Shot Time",
	Type.SHOT_SPREAD: "+ Shot Spread",
	Type.SHOT_LIFETIME: "+ Shot Range" 
}


static var UPGRADE_VALUES = {
	Type.SHOT_NUMBER: {"amount": 1.0, "operation": Operation.ADD},
	Type.SHOT_TIME: {"amount": -0.05, "operation": Operation.ADD},
	Type.SHOT_SPREAD: {"amount": 10.0, "operation": Operation.ADD},
	Type.SHOT_LIFETIME: {"amount": 0.25, "operation": Operation.ADD}
}


@export var score_text: ScoreText
@export var base_upgrade_cost := 0
@export var upgrade_audio_stream : AudioStream
@export var failed_audio_stream : AudioStream


func _ready():
	SignalBus.upgrade_button_pressed.connect(_on_upgrade_button_pressed)


func _on_upgrade_button_pressed(upgrade_node: UpgradeNode, upgrade_type: int):
	# Testing against upgrade base cost time the node's upgrade level for scaling
	# + 1 because starts at level zero
	var upgrade_cost = base_upgrade_cost * (upgrade_node.level + 1)
	if score_text.score >= upgrade_cost:
		score_text.score -= upgrade_cost
		var upgrade_info = UPGRADE_VALUES[upgrade_type]
		SignalBus.upgrade_value_changed.emit(
			upgrade_type, 
			upgrade_info.amount,
			upgrade_info.operation
		)
		%SoundManager.play_sound(upgrade_audio_stream)
		upgrade_node.change_claim_state(true)
	else:
		%SoundManager.play_sound(failed_audio_stream)
