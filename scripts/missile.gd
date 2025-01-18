extends CharacterBody2D
class_name Missile


@export var speed : float = 200
@export var ang_acc : float = 1

var lifetime : float = 2
var life_counter : float = 0

var world : World
var exploding : bool = false

func _ready():
	var root = get_tree().root
	world = root.get_child(root.get_child_count() - 1)
	
	%CollisionArea.body_entered.connect(_on_body_entered)
	%ExplosionArea.body_entered.connect(_on_explosion_entered)
	
	for n in %ExplosionArea.get_children():
		var node : Node2D = n
		n.scale = Vector2.ZERO
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if exploding:
		return
	
	%MovementComponent.move_and_rotate(
		delta, 
		self, 
		world.player.global_position,
		speed,
		ang_acc)
		
	life_counter += delta
	if life_counter > lifetime:
		exploding = true
		_explode()


func setup (missile_stats : WeaponResource) :
	global_position = missile_stats.projectile_position
	rotation = missile_stats.rotation
	speed = missile_stats.speed
	ang_acc = missile_stats.angular_acc
	scale = Vector2(missile_stats.scale, missile_stats.scale)
	lifetime = missile_stats.lifetime
	collision_mask = missile_stats.mask
	%CollisionArea.collision_mask = collision_mask
	%ExplosionArea.collision_mask = collision_mask
		
		
func _on_body_entered(body):
	if body == self:
		return
	if body.is_in_group("Player"):
		_explode()


func _on_explosion_entered(body):
	if body.is_in_group("Player"):
		SignalBus.player_killed.emit()


func _on_collision_area_entered(area):
	if area.is_in_group("Projectile"):
		_explode()

	
func _explode():
	# Stop the missile:
	%MovementComponent.stop = true
	
	var tween = create_tween() as Tween
	
	tween.finished.connect(func(): _end_explosion())
	
	# Tween the shader health parameter and position simultaneously
	tween.tween_method(_scale_explosion, 0.0, 1.0, 0.5) \
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)
		

func _scale_explosion(new_scale: float):
	for n in %ExplosionArea.get_children():
		n.scale = Vector2(new_scale, new_scale)


func _end_explosion():
	var tween = create_tween() as Tween

	# Ensure queue_free() is only called after tween completes
	tween.finished.connect(func(): queue_free())
	
	# Tween the shader health parameter and position simultaneously
	tween.tween_method(_scale_explosion, 1.0, 0.0, 0.75) \
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)
