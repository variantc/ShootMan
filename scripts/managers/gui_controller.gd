extends Node
class_name GUI_Controller


var upgrades = {}  # Start with empty dictionary


func _ready():
	# Make GUI non-pausing
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	%PauseScreen.set_visible(false)
	%GameOverScreen.set_visible(false)
	%GameOverScreen.modulate.a = 0  # Start fully transparent
	
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.pause_state_changed.connect(_on_pause_state_changed)
	SignalBus.slow_motion_started.connect(_on_slow_motion_started)
		
	%RestartButton.button_up.connect(_on_restart_button_up)
	_setup_upgrade_buttons()
	

func _setup_upgrade_buttons():
	# Initialize dictionary in _ready when nodes are available
	upgrades = {
		UpgradeManager.Type.SHOT_NUMBER: %ShotButton,
		UpgradeManager.Type.SHOT_TIME: %TimeButton,
		UpgradeManager.Type.SHOT_SPREAD: %SpreadButton,
		UpgradeManager.Type.SHOT_LIFETIME: %LifetimeButton
	}
	
	# Connect the button up signals of each button
	for upgrade_type in upgrades:
		upgrades[upgrade_type].button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(upgrade_type)
		)


func _input(event):
	if event.is_action_pressed("Pause"): # and not is_game_over:
		%GameStateManager.toggle_pause()


func _on_pause_state_changed(paused : bool):
	%PauseScreen.set_visible(paused)


func _on_slow_motion_started(duration : float):
	%GameOverScreen.set_visible(true)
	var tween = create_tween()
	tween.tween_property(%GameOverScreen, "modulate:a", 1.0, duration)
	

func _on_game_over():
	pass


func _on_restart_button_up():
	%GameStateManager.restart_game()
