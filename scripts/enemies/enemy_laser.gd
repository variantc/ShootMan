extends EnemyStandard
class_name EnemyLaser


var FIRE_CHARGE = 2
var FIRE_TIME = 2

var _is_firing = false
var fire_time = 0

var player_hit_time = 0
var laser_player : Player = null

@export var laser_line : Line2D
@export var laser_area : Area2D
@export var laser_collision : CollisionShape2D


func _ready():
	laser_area.body_entered.connect(_on_laser_body_entered)
	laser_area.body_exited.connect(_on_laser_body_exited)
	laser_line.set_visible(false)
	super._ready()


func _physics_process(delta):
	fire_time += delta
	if _is_firing and fire_time >= FIRE_TIME:
		_start_charge_laser()
	if not _is_firing and fire_time >= FIRE_CHARGE:
		_start_fire_laser()
		
	laser_line.width = 10 + 5 * sin(10*fire_time + randf_range(-1,1))
	
	movement_component.stop = _is_firing
		
	if laser_player:
		player_hit_time += delta
		laser_player.modulate_sprite(player_hit_time)
		if player_hit_time >= 1.0:
			SignalBus.player_killed.emit()


func _start_charge_laser():
	_is_firing = false
	laser_line.set_visible(false)
	if laser_player:
		_on_laser_body_exited(laser_player)
	fire_time = 0


func _start_fire_laser():
	laser_line.set_visible(true)
	_is_firing = true
	_check_overlapping_bodies()
	fire_time = 0
	

func _check_overlapping_bodies():
	var overlapping = laser_area.get_overlapping_bodies()
	for body in overlapping:
		if body is Player:
			_on_laser_body_entered(body)


func _on_laser_body_entered(body):
	if _is_firing and body is Player:
		laser_player = body


func _on_laser_body_exited(body):
	if body is Player:
		laser_player = body
		laser_player.modulate_sprite(0)
		player_hit_time = 0
		laser_player = null
