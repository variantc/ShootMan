extends EnemyStandard
class_name EnemyLaser


var _is_firing = false
var time = 0


func _ready():
	$LaserLine/LaserArea.body_entered.connect(_on_laser_body_enetered)


func _physics_process(delta):
	time += delta
	$LaserLine.width = 10 + 5 * sin(10*time + randf_range(-1,1))


func _on_laser_body_enetered(body):
	print_debug(body.name)
