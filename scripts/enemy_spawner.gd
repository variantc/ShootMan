extends Node

@export var enemy_standard_scene : PackedScene
@export var spawn_time : float

var counter = 0


func _process(delta):
	counter += delta
	if counter > spawn_time:
		counter = 0
		var enemy = enemy_standard_scene.instantiate()
		enemy.global_position = _get_random_edge_position()
		self.add_child(enemy)


func _get_random_edge_position():
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_width = viewport_rect.size.x
	var screen_height = viewport_rect.size.y
	
	var offset := 25.0
	
	match randi() % 4:
		0: # Top edge
			return Vector2(randf() * screen_width + offset, -offset)
		1: # Bottom edge
			return Vector2(randf() * screen_width, screen_height + offset)
		2: # Left edge
			return Vector2(-offset, randf() * screen_height)
		3: # Right edge
			return Vector2(screen_width + offset, randf() * screen_height)
