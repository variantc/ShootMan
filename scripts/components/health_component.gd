extends Node2D
class_name HealthComponent


@export var health : float = 100
var start_health : float
@export var health_bar : ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	start_health = health
	set_health_bar()


func take_damage(amount : float):
	health -= amount
	health_bar.value = 100 * health/start_health
	if health <= 0:
		print_debug(self.name)
		SignalBus.all_health_removed.emit(self.get_parent(), false)
		health = start_health


func set_health_bar():
	health_bar.value = 100 * health/start_health
