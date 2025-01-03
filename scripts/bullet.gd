extends Area2D
class_name Bullet

@onready var world : World

var speed : float = 0.0
var strength : float = 0.0
var orig_strength : float = 0.0
var scatter : int = 0
var direction : Vector2 = Vector2.ZERO
var lifetime : float = 5
var life_counter : float = 0
var repeat_scatter : bool = false

var bullet_resource : BulletResource

func _ready():
	world = get_tree().root.get_child(0)


func setup( bullet_stats ):    # new_lifetime CURRENTLY UNUSED

	global_position = bullet_stats.position
	rotation = bullet_stats.rotation
	speed = bullet_stats.speed
	strength = bullet_stats.strength
	orig_strength = strength
	scatter = bullet_stats.scatter
	repeat_scatter = bullet_stats.repeat_scatter
	scale = Vector2(bullet_stats.scale, bullet_stats.scale)
	lifetime = bullet_stats.lifetime
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
	if scatter > 0:
		for i in range(scatter):
			var new_bullet = world.player.bullet_scene.instantiate() as Bullet
			world.add_child(new_bullet)
			# Calculate spread rotation
			var scatter_angle = deg_to_rad(randf()*360)  # You can adjust this base spread angle
			var new_rot = global_rotation + scatter_angle * (i - (scatter - 1) / 2.0)
			
			# Check if we want repeat scattering:
			var sub_scatter = scatter-1 if repeat_scatter else 0
			
			var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			bullet_stats.posisiton = global_position
			bullet_stats.rotation = new_rot
			bullet_stats.speed = speed
			bullet_stats.strength = orig_strength
			bullet_stats.scatter = scatter
			new_bullet.setup(bullet_stats)
			# Recalculate direction for the new bullet
			new_bullet.direction = Vector2(cos(new_bullet.rotation), sin(new_bullet.rotation)).normalized()

	# Remove the original bullet
	queue_free()
