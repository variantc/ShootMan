# GUI_Controller.gd
extends Node

var upgrades = {}  # Start with empty dictionary

func _ready():
	# Initialize dictionary in _ready when nodes are available
	upgrades = {
		"shot_number": %ShotButton,
		"shot_time": %TimeButton,
		"shot_spread": %SpreadButton,
		"shot_lifetime": %LifetimeButton
	}
	
	for upgrade_type in upgrades:
		upgrades[upgrade_type].button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(upgrade_type)
		)
