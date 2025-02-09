extends Area2D
class_name Bullet


var speed : float = 0.0
var strength : float = 0.0
var orig_strength : float = 0.0
var scatter : int = 0
var direction : Vector2 = Vector2.ZERO
var lifetime : float = 5
var life_counter : float = 0
var repeat_scatter : bool = false

var bullet_stats : WeaponResource


func _ready():
	var root = get_tree().root
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func setup( new_bullet_stats : WeaponResource ):

	global_position = new_bullet_stats.projectile_position
	rotation = new_bullet_stats.rotation
	speed = new_bullet_stats.speed
	strength = new_bullet_stats.strength
	orig_strength = strength
	scatter = new_bullet_stats.scatter
	repeat_scatter = new_bullet_stats.repeat_scatter
	scale = Vector2(new_bullet_stats.scale, new_bullet_stats.scale)
	lifetime = new_bullet_stats.lifetime
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	collision_mask = new_bullet_stats.mask


func _process(delta):
	# Move the bullet in its direction
	position += direction * speed * delta
	
	life_counter += delta
	if life_counter > lifetime:
		split_bullets()


func _on_area_entered(area):
	print_debug("hit area")
	if area.is_in_group("Enemy"):    # This is the enemy_nest??
		print_debug("hit enemy group")
		#area.hit(self, direction, speed)
		area.hit()


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit(self, direction, speed)		# Enemy.hit will reduce this bullet's strength
	if strength <= 0:
		# Use call_deferred to delay the split_bullets() call
		call_deferred("split_bullets")


func split_bullets():
	if scatter > 0:
		for i in range(scatter):
			var new_bullet = Refs.player.bullet_scene.instantiate() as Bullet
			Refs.world.add_child(new_bullet)
			# Calculate spread rotation
			var scatter_angle = deg_to_rad(randf()*360)  # You can adjust this base spread angle
			var new_rot = global_rotation + scatter_angle * (i - (scatter - 1) / 2.0)
			
			# Check if we want repeat scattering:
			var sub_scatter = scatter-1 if repeat_scatter else 0
			
			var sub_bullet_stats = load("res://resources/instances/starting_gun.tres") as WeaponResource
			sub_bullet_stats.bullet_position = global_position
			sub_bullet_stats.rotation = new_rot
			sub_bullet_stats.speed = speed
			sub_bullet_stats.strength = orig_strength
			sub_bullet_stats.scatter = sub_scatter
			new_bullet.setup(bullet_stats)
			# Recalculate direction for the new bullet
			new_bullet.direction = Vector2(cos(new_bullet.rotation), sin(new_bullet.rotation)).normalized()

	# Remove the original bullet
	queue_free()
