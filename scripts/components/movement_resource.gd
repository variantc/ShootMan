extends Resource
class_name MovementResource


var body: CharacterBody2D
var speed: float
var ang_acc: float
var reverse: bool = false

func _init(init_body, init_speed, init_ang_acc, init_reverse = false):
	body = init_body
	speed = init_speed
	ang_acc = init_ang_acc
	reverse = init_reverse
