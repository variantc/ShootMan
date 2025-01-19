extends Node

@export var destroyers : Array[Area2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	for d in destroyers:
		d.area_entered.connect(_on_destroyer_entered)


func _on_destroyer_entered(body):
	body.queue_free()
