extends Node
class_name ShootComponent


@export var bullet_scene : PackedScene
@export var missile_scene : PackedScene

var counter : float = 0
var parent : Node

const PLAYER_LAYER_MASK := 1
const ENEMY_LAYER_MASK := 2


func _ready():
	parent = get_parent()
	

func shoot(delta, weapon_resource : WeaponResource):
	if weapon_resource.shot_number == 0:
		print("ERROR: Shot number is zero!")
		return
		
	counter += delta
	var rad_spread = weapon_resource.shot_spread * PI/180
	if counter > weapon_resource.shot_time:
		counter = 0.0
		for i in range(weapon_resource.shot_number):
			var rot = parent.global_rotation
			if weapon_resource.shot_number > 1:
				rot = parent.global_rotation - (rad_spread)/2 + i * rad_spread/(weapon_resource.shot_number-1)
			
			
			var projectile

			match weapon_resource.projectile_type:
				WeaponResource.Type.BULLET:
					projectile = bullet_scene.instantiate() as Bullet
				WeaponResource.Type.MISSILE:
					projectile = missile_scene.instantiate() as Missile
			
			#projectile.collision_mask = weapon_resource.mask
			parent.get_parent().add_child(projectile)
			
			#var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			var weapon_stats = weapon_resource.duplicate() as WeaponResource
			
			# Offset spawn position to avoid collider issues:
			var spawn_offset = Vector2.RIGHT.rotated(rot) * 20  # Adjust 20 to whatever offset you want
			weapon_stats.projectile_position = parent.global_position + spawn_offset
			weapon_stats.rotation = rot
			
			##TODO: Check updated
			#if parent is Player:
				#projectile_stats.mask = ENEMY_LAYER_MASK
			#if parent is EnemyMissile:
				#projectile_stats.mask = PLAYER_LAYER_MASK
				
			projectile.setup(weapon_stats)
