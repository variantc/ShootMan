extends CharacterBody2D
class_name Missile


@export var speed : float = 200
@export var ang_acc : float = 1

var lifetime : float = 5
var life_counter : float = 0

var world : World


func _ready():
	var root = get_tree().root
	world = root.get_child(root.get_child_count() - 1)
	
	%CollisionArea.body_entered.connect(_on_body_entered)
	
	%ExplosionArea.process_mode = Node.PROCESS_MODE_DISABLED
	
	%ExplosionArea.body_entered.connect(_on_explosion_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	%MovementComponent.move_and_rotate(
		delta, 
		self, 
		world.player.global_position,
		speed,
		ang_acc)
		
	life_counter += delta
	if life_counter > lifetime:
		_explode()
		
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		_explode()


func _on_explosion_entered(body):
	if body.is_in_group("Player"):
		SignalBus.player_killed.emit()


func _explode():
	%ExplosionArea.process_mode = Node.PROCESS_MODE_INHERIT
	print_debug("BOOOM")
	queue_free()
