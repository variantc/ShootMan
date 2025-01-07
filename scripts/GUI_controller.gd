# GUI_Controller.gd
extends Node

var upgrades = {}  # Start with empty dictionary

func _ready():
	# Initialize dictionary in _ready when nodes are available
	upgrades = {
		UpgradeManager.Type.SHOT_NUMBER: %ShotButton,
		UpgradeManager.Type.SHOT_TIME: %TimeButton,
		UpgradeManager.Type.SHOT_SPREAD: %SpreadButton,
		UpgradeManager.Type.SHOT_LIFETIME: %LifetimeButton
	}


	for upgrade_type in upgrades:
		print(upgrade_type)
		upgrades[upgrade_type].button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(upgrade_type)
		)
