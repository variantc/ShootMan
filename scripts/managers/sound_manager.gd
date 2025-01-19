extends Node
class_name SoundManager


func play_sound(stream: AudioStream, position: Vector2 = Vector2(0,0)):
	# Dynamically create an AudioStreamPlayer2D node
	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.global_position = position
	add_child(player)
	
	# Play the sound and queue the player for deletion when done
	player.play()
	player.finished.connect(player.queue_free)
