extends Area2D
class_name EnemyNest


@export var health_component : HealthComponent


func _ready():
	SignalBus.all_health_removed.connect(_on_all_health_removed)
	area_entered.connect(_on_area_entered)
	
	health_component.health_bar.set_visible(false)
	
	
func _on_all_health_removed(node : Node, health_left : bool):
	if node == self:
		die()
		
		
func die():
	SignalBus.enemy_nest_destroyed.emit(self)
	queue_free()


func hit():
	health_component.take_damage(10)
	health_component.health_bar.set_visible(true)


func _on_area_entered(area):
	# Do we want to do something on bullet hit - kill it?
	if Refs.world.DEBUG:
		print_debug(area.name + " area")
