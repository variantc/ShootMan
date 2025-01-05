extends Node


signal drop_to_player(drop : DropStandard)
signal drop_picked_up(audio : AudioStreamPlayer2D)

signal enemy_spawned(enemy : EnemyStandard)
signal enemy_killed(enemy : EnemyStandard, audio : AudioStreamPlayer2D)
