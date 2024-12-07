extends Area2D
#class_name Bullet

var speed : float = 0.0
var strength : float = 0.0
var direction : Vector2 = Vector2.ZERO

var lifetime : float = 10
var life_counter : float = 0

func _ready():
	pass

func setup(pos, rot, new_speed : float, new_strength : float):
	global_position = pos
	rotation = rot
	speed = new_speed
	strength = new_strength
	direction = Vector2(cos(rotation), sin(rotation)).normalized()


func _process(delta):
	# Move the bullet in its direction
	position += direction * speed * delta
	
	life_counter += delta
	if life_counter > lifetime:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit(self)		# Enemy.hit will reduce this bullet's strength
	if strength <= 0:
		queue_free()
