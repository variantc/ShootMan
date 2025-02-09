extends Node


#@warning_ignore("unused_signal") signal drop_to_player(drop : DropStandard)
@warning_ignore("unused_signal") signal drop_picked_up(audio : AudioStreamPlayer2D)

@warning_ignore("unused_signal") signal enemy_spawned(enemy : EnemyStandard)
@warning_ignore("unused_signal") signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)

@warning_ignore("unused_signal") signal player_killed
@warning_ignore("unused_signal") signal slow_motion_started(duration : float)
@warning_ignore("unused_signal") signal game_over
@warning_ignore("unused_signal") signal pause_state_changed(paused : bool)

@warning_ignore("unused_signal") signal upgrade_node_claim_status_changed(upgrade_node : UpgradeNode, claimed : bool)
@warning_ignore("unused_signal") signal upgrade_value_changed(upgrade_type : int, upgrade_value : int, upgrade_operation : int)
@warning_ignore("unused_signal") signal upgrade_button_pressed(upgrade_node : UpgradeNode, upgrade_type : int)
@warning_ignore("unused_signal") signal debug_upgrade_button_pressed(upgrade_type : int)
#@warning_ignore("unused_signal") signal apply_upgrade(upgrade_type: String, amount)

@warning_ignore("unused_signal") signal all_health_removed(node : Node, health_left : bool)

@warning_ignore("unused_signal") signal enemy_nest_destroyed(nest : EnemyNest)
