extends Sprite2D
class_name DamageSprite


@export var default_shader_material: ShaderMaterial
var is_material_initialized := false


func _ready():
	# Access the ShaderMaterial
	#var shader_material = ShaderMaterial.new()
	#shader_material.shader = damage_material.shader

	# Apply the ShaderMaterial to the Sprite
	#self.material = shader_material

	# Ensure we get a unique copy of the material for this instance
	if material:
		# Force a deep copy of the material
		var original_material = material
		material = null  # Clear the reference first
		material = original_material.duplicate()
	elif default_shader_material:
		material = default_shader_material.duplicate()
	else:
		push_error("No material assigned to DamageSprite! Assign a ShaderMaterial either directly to the Sprite or via the default_shader_material export variable.")
		return
		
	# Handle the noise texture specifically
	var noise_texture = material.get_shader_parameter("burn_noise")
	if noise_texture and noise_texture is NoiseTexture2D:
		var new_noise_texture = noise_texture.duplicate()
		new_noise_texture.noise = noise_texture.noise.duplicate()
		material.set_shader_parameter("burn_noise", new_noise_texture)
				
	is_material_initialized = true
	_randomise_shader_noise()


func _process(delta):
	if not is_material_initialized:
		return
		
	# Update the rotation angle based on some logic (replace this with your own logic)
	rotation += delta
	self.material.set_shader_parameter("angle", rotation)


func _randomise_shader_noise():	
	if not is_material_initialized:
		return
		
	var noise_texture = material.get_shader_parameter("burn_noise")
	if noise_texture and noise_texture is NoiseTexture2D:
		if noise_texture.noise:
			noise_texture.noise.seed = randi() % 10000


# Return true if dead, false if not
func show_damage(prev: float, current: float, start: float) -> bool:
	if not is_material_initialized:
		push_error("Cannot show damage: Material not initialized")
		return current <= 0
		
	var dam_time = 0.3
	# Create and configure a single tween
	var tween = create_tween() as Tween
	
	# Ensure queue_free() is only called after tween completes
	tween.finished.connect(func(): if current <= 0 : queue_free())
	if current <= 0:
		return true
	
	var start_health_left = prev / start
	# Update shader to reflect new health
	var health_left = max(current / start, 0)
	
	# Tween the shader health parameter and position simultaneously
	tween.tween_method(_set_shader_hp_left, start_health_left, health_left, dam_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)
		
	return false


func _set_shader_hp_left(hp_left: float):
	if is_material_initialized:
		material.set_shader_parameter("hp_left", hp_left)
