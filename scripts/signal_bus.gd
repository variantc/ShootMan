extends Node


signal drop_to_player(drop : DropStandard)
signal drop_picked_up(audio : AudioStreamPlayer2D)

signal enemy_spawned(enemy : EnemyStandard)
signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)

signal upgrade_button_pressed(upgrade_type: String)
signal apply_upgrade(upgrade_type: String, amount)

signal player_killed
signal slow_motion_started(duration : float)
signal game_over
signal pause_state_changed(paused : bool)
