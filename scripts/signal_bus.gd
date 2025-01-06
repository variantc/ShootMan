extends Node


signal drop_to_player(drop : DropStandard)
signal drop_picked_up(audio : AudioStreamPlayer2D)

signal enemy_spawned(enemy : EnemyStandard)
signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)

signal button_shot_number_up
signal button_shot_spread_up

signal change_shot_number(amount : int)
signal change_shot_spread(amount : float)
