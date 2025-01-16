extends Node
class_name ShootComponent


@export var bullet_scene : PackedScene

var counter : float = 0
var parent : Node


func _ready():
	parent = get_parent()
	

func shoot(delta, gun_resource : GunResource, mask : int):
	if gun_resource.shot_number == 0:
		print("ERROR: Shot number is zero!")
		return
		
	counter += delta
	var rad_spread = gun_resource.shot_spread * PI/180
	if counter > gun_resource.shot_time:
		counter = 0.0
		for i in range(gun_resource.shot_number):
			var rot = parent.global_rotation
			if gun_resource.shot_number > 1:
				rot = parent.global_rotation - (rad_spread)/2 + i * rad_spread/(gun_resource.shot_number-1)
			var bullet = bullet_scene.instantiate() as Bullet
			
			bullet.collision_mask = mask
			parent.get_parent().add_child(bullet)
			
			#var bullet_stats = load("res://resources/bullet.tres") as BulletResource
			var bullet_stats = gun_resource.current_bullet
			bullet_stats.bullet_position = parent.global_position
			bullet_stats.rotation = rot
			
			bullet.setup(bullet_stats)
