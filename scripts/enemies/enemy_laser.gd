extends EnemyStandard
class_name EnemyLaser



var fire_charge = 2
var fire_time = 2
var _is_firing = false
var time = 0

var hit_time = 0
var laser_player : Player = null

@export var laser_line : Line2D
@export var laser_area : Area2D


func _ready():
	laser_area.body_entered.connect(_on_laser_body_enetered)
	laser_area.body_exited.connect(_on_laser_body_exited)
	laser_line.set_visible(false)
	super._ready()


func _physics_process(delta):
	time += delta
	if _is_firing and time >= fire_time:
		_is_firing = false
		laser_line.set_visible(false)
		time = 0
	if not _is_firing and time >= fire_charge:
		laser_line.set_visible(true)
		_is_firing = true
		time = 0
		
	laser_line.width = 10 + 5 * sin(10*time + randf_range(-1,1))
	
	movement_component.stop = _is_firing
		
	if laser_player:
		hit_time += delta
		laser_player.modulate_sprite(hit_time)


func _on_laser_body_enetered(body):
	if _is_firing and body is Player:
		laser_player = body


func _on_laser_body_exited(body):
	if body is Player:
		laser_player = body
		laser_player.modulate_sprite(0)
		laser_player = null
