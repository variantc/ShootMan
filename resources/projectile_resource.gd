extends Resource
class_name ProjectileResource

enum Type { BULLET, MISSILE }

@export var id: String
var projectile_position : Vector2 
var rotation : float 
@export var speed : float
@export var angular_acc : float = 0
@export var strength : float
@export var scatter : int = 0
@export var repeat_scatter : bool = false
@export var scale : float = 1.0
@export var lifetime : float = 5
@export var mask: int
