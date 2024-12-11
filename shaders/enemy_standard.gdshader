shader_type canvas_item;

// Uniform variables to control the shader
uniform vec4 shade_color : source_color = vec4(0.0, 0.0, 0.0, 0.5); // Default to semi-transparent black
uniform float shade_intensity : hint_range(0.0, 1.0) = 0.5; // Control shade intensity

void fragment() {
    // Sample the original sprite color
    vec4 original_color = texture(TEXTURE, UV);
	vec4 shaded_color = vec4(0.0);
	
    if(original_color.a < 0.0001) 
	{
		shaded_color = vec4(0.0);
	}
	else 
	{
    // Mix the original color with the shade color based on intensity
    shaded_color = mix(original_color, shade_color, shade_intensity);
	}
	
    
    // Output the final color
    COLOR = shaded_color;
}
