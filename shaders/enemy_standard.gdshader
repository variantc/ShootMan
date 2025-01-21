shader_type canvas_item;

#include "res://shaders/characters.gdshaderinc"

#define BREATHING_PACE 4.0

// Uniform variables to control the shader
uniform vec4 shade_color : source_color = vec4(0.0, 0.0, 0.0, 0.5); // Default to semi-transparent black
uniform float shade_intensity : hint_range(0.0, 1.0) = 0.5; // Control shade intensity

group_uniforms taking_damage;
uniform sampler2D burn_gradient;
uniform sampler2D burn_noise;
uniform float hp_left: hint_range(0.0, 1.0, 0.05);
group_uniforms;

vec4 apply_shade(vec4 original_color) {
    if(original_color.a < 0.0001) {
        return vec4(0.0);
    }
    return mix(original_color, shade_color, shade_intensity);
}

void apply_damage_fragment(inout vec4 c, vec2 uv) {
	float noise_r = texture(burn_noise, uv).r;
	float ty = uv.y + mix(-2.0, 1.0, hp_left) + noise_r;
	vec4 grad_tex = texture(
		burn_gradient, 
		vec2(uv.y, ty));
	
	float mix_ratio = clamp(ty, 0.0, 1.0);;
	c = vec4(mix(grad_tex, c, mix_ratio).rgb, min(grad_tex.a, c.a));
}

void apply_damage_vertex(inout vec2 v) {
	
	float scale = 1.0 + smoothstep(0.7, 1.0, 1.0 - hp_left);
	v *= scale;
}

void vertex() {
	//breath(VERTEX, BREATHING_PACE); 		// characters.inc

	apply_damage_vertex(VERTEX);
}


void fragment() {

	//flash_on_hit(COLOR.rgb); 		// characters.inc
	COLOR = apply_shade(COLOR);
	flash_on_hit(COLOR.rgb); 		// characters.inc

	
	apply_damage_fragment(COLOR, UV);
	
	#ifdef DEBUG_MODE_ON
	debug_draw_dots_at_vertices(UV, COLOR, TEXTURE);		// debug_utils.inc
	#endif
}

