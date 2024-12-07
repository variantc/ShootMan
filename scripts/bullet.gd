extends Area2D
class_name Bullet

var player : Player

var speed : float = 0.0
var strength : float = 0.0
var orig_strength : float = 0.0
var spread : int = 0
var direction : Vector2 = Vector2.ZERO
var lifetime : float = 10
var life_counter : float = 0

func _ready():
	player = get_tree().root.get_child(0).find_child('Player')

func setup(pos, rot, new_speed : float, new_strength : float, new_spread : int):
	global_position = pos
	rotation = rot
	speed = new_speed
	strength = new_strength
	orig_strength = strength
	spread = new_spread
	direction = Vector2(cos(rotation), sin(rotation)).normalized()

func _process(delta):
	# Move the bullet in its direction
	position += direction * speed * delta
	
	life_counter += delta
	if life_counter > lifetime:
		split_bullets()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit(self)		# Enemy.hit will reduce this bullet's strength
	if strength <= 0:
		# Use call_deferred to delay the split_bullets() call
		call_deferred("split_bullets")

func split_bullets():
	if spread > 0:
		for i in range(spread):
			var new_bullet = player.bullet_scene.instantiate() as Bullet
			get_tree().root.get_child(0).add_child(new_bullet)
			#new_bullet.global_position = Vector2(575, 350)
			# Calculate spread rotation
			var spread_angle = deg_to_rad(45)  # You can adjust this base spread angle
			var new_rot = rotation + spread_angle * (i - (spread - 1) / 2.0)
			
			new_bullet.setup(global_position, 
							new_rot, 
							speed, 
							orig_strength, 
							max(spread-1,0))
			# Recalculate direction for the new bullet
			new_bullet.direction = Vector2(cos(new_bullet.rotation), sin(new_bullet.rotation)).normalized()
			#new_bullet.direction = -direction
			
			# Optional: Reduce strength or speed of split bullets
			#new_bullet.strength = 0.5 * strength
			#new_bullet.speed = 0.75 * speed
	
	# Remove the original bullet
	queue_free()
