extends Node


@warning_ignore("unused_signal") signal drop_to_player(drop : DropStandard)
@warning_ignore("unused_signal") signal drop_picked_up(audio : AudioStreamPlayer2D)

@warning_ignore("unused_signal") signal enemy_spawned(enemy : EnemyStandard)
@warning_ignore("unused_signal") signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)

@warning_ignore("unused_signal") signal upgrade_button_pressed(upgrade_type: String)
@warning_ignore("unused_signal") signal apply_upgrade(upgrade_type: String, amount)

@warning_ignore("unused_signal") signal player_killed
@warning_ignore("unused_signal") signal slow_motion_started(duration : float)
@warning_ignore("unused_signal") signal game_over
@warning_ignore("unused_signal") signal pause_state_changed(paused : bool)
