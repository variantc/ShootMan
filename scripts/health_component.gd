extends Node
class_name HealthComponent


var health : float = 100
var start_health : float
@export var health_bar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func take_damage(amount : float):
	health -= amount
	health_bar.value = 100 * health/start_health
	if health <= 0:
		SignalBus.all_health_removed.emit(self, false)
		health = start_health
