# GUI_Controller.gd
extends Node

var upgrades = {}  # Start with empty dictionary

var is_paused := false
signal restart_b

func _ready():
	# Make GUI non-pausing
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	%PauseScreen.set_visible(false)
	%GameOverScreen.set_visible(false)
	
	SignalBus.player_killed.connect(_on_player_killed)
	
	# Initialize dictionary in _ready when nodes are available
	upgrades = {
		UpgradeManager.Type.SHOT_NUMBER: %ShotButton,
		UpgradeManager.Type.SHOT_TIME: %TimeButton,
		UpgradeManager.Type.SHOT_SPREAD: %SpreadButton,
		UpgradeManager.Type.SHOT_LIFETIME: %LifetimeButton
	}


	for upgrade_type in upgrades:
		print_debug(upgrade_type)
		upgrades[upgrade_type].button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(upgrade_type)
		)
		
	%RestartButton.button_up.connect(_on_restart_button_up)


func _input(event):
	if event.is_action_pressed("Pause"): # and not is_game_over:
		toggle_pause()

		
func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	if is_paused:
		%PauseScreen.set_visible(true)
	else:
		%PauseScreen.set_visible(false)


func _on_player_killed():
	%GameOverScreen.set_visible(true)
	get_tree().paused = true


func _on_restart_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene.call_deferred()
