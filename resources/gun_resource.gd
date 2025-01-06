extends Resource
class_name GunResource


@export var id : String
@export var shot_time : float = 1 :
	set(value):
		shot_time = max(0.05, value)
@export var shot_number : int = 1 :
	set(value):
		shot_number = value
@export var shot_spread : int = 5
@export var current_bullet : BulletResource
