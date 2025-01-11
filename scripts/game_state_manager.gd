extends Node
class_name GameStateManager


const SLOW_MOTION_SCALE := 0.2
const SLOW_MOTION_DURATION := 1.0

var is_paused := false


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.player_killed.connect(_on_player_killed)
	

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	SignalBus.pause_state_changed.emit(is_paused)


func _on_player_killed():
	SignalBus.slow_motion_started.emit(SLOW_MOTION_DURATION)
	await do_slow_motion()
	get_tree().paused = true
	SignalBus.game_over.emit()
		

func do_slow_motion():
	var tween = create_tween()
	Engine.time_scale = 1.0
	tween.tween_property(Engine, "time_scale", SLOW_MOTION_SCALE, 0.1)
	await get_tree().create_timer(SLOW_MOTION_DURATION * SLOW_MOTION_SCALE).timeout
	Engine.time_scale = 1.0
	

func restart_game():
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().reload_current_scene.call_deferred()
