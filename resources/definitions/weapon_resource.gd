extends Resource
class_name WeaponResource


enum Type { BULLET, MISSILE }

@export var id : String
@export var shot_time : float = 1 :
	set(value):
		shot_time = max(0.05, value)
@export var shot_number : int = 1 :
	set(value):
		shot_number = value
@export var shot_spread : float = 2.5
@export var projectile_type : WeaponResource.Type

@export var speed : float
@export var angular_acc : float = 0
@export var strength : float
@export var scatter : int = 0
@export var repeat_scatter : bool = false
@export var scale : float = 1.0
@export var lifetime : float
@export var mask: int

var projectile_position : Vector2 
var rotation : float 
