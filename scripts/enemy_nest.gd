extends Area2D


@export var health_component : HealthComponent


func _ready():
	SignalBus.all_health_removed.connect(_on_all_health_removed)
	area_entered.connect(_on_area_entered)
	
	
func _on_all_health_removed(node : Node, health_left : bool):
	if node == self:
		die()
		
		
func die():
	queue_free()


func hit():
	print("HIT")


func _on_area_entered(area):
	print_debug(area.name + " area")
	health_component.take_damage(10)
