# GUI_Controller.gd
extends Node

var upgrades = {}  # Start with empty dictionary

var is_paused := false

func _ready():
	# Make GUI non-pausing
	process_mode = Node.PROCESS_MODE_ALWAYS
	
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


func _input(event):
	if event.is_action_pressed("Pause"): # and not is_game_over:
		toggle_pause()

		
func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	if is_paused:
		%PauseScreen.visible = true
	else:
		%PauseScreen.visible = false
