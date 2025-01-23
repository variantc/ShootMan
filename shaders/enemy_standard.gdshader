shader_type canvas_item;

#include "res://shaders/characters.gdshaderinc"

#define BREATHING_PACE 4.0

// Uniforms
uniform sampler2D burn_gradient;
uniform sampler2D burn_noise;
uniform sampler2D normal_map;
uniform float hp_left : hint_range(0.0, 1.0, 0.05);
uniform float normal_intensity : hint_range(0.0, 1.0) = 1.0;
uniform vec2 light_direction = vec2(0.5, -0.5);
uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
uniform float object_rotation = 0.0; // <--- New uniform for rotation

// Shade effect
uniform vec4 shade_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float shade_intensity : hint_range(0.0, 1.0) = 0.5;

vec4 apply_shade(vec4 original_color) {
	if (original_color.a < 0.0001) {
		return vec4(0.0);
	}
	return mix(original_color, shade_color, shade_intensity);
}

// Damage effect
void apply_damage_fragment(inout vec4 c, vec2 uv) {
	float noise_r = texture(burn_noise, uv).r;
	float ty = uv.y + mix(-2.0, 1.0, hp_left) + noise_r;
	vec4 grad_tex = texture(burn_gradient, vec2(uv.y, ty));

	float mix_ratio = clamp(ty, 0.0, 1.0);
	c = vec4(mix(grad_tex, c, mix_ratio).rgb, min(grad_tex.a, c.a));
}

// Damage scaling effect
void apply_damage_vertex(inout vec2 v) {
	float scale = 1.0 + smoothstep(0.7, 1.0, 1.0 - hp_left);
	v *= scale;
}

// Normal mapping with rotation
vec3 apply_normal_map(vec2 uv, vec3 base_color, float rot) {
	// Sample the normal map
	vec3 normal = texture(normal_map, uv).rgb * 2.0 - 1.0;
	normal.xy *= normal_intensity;

	// Create a rotation matrix
	float cos_angle = cos(rot);
	float sin_angle = sin(rot);
	mat2 rotation_matrix = mat2(
		vec2(cos_angle, -sin_angle),
		vec2(sin_angle, cos_angle)
	);

	// Rotate the normal map
	normal.xy = rotation_matrix * normal.xy;

	// Normalize light direction
	vec2 normalized_light_dir = normalize(light_direction);

	// Compute lighting
	float light_factor = dot(normal.xy, normalized_light_dir) * 0.5 + 0.5;
	light_factor = clamp(light_factor, 0.1, 1.0);

	// Blend normal lighting with base color
	return mix(base_color, base_color * light_color * light_factor, normal_intensity);

}

void vertex() {
	apply_damage_vertex(VERTEX);
}

void fragment() {
	// Get base sprite color
	vec4 base_color = texture(TEXTURE, UV);

	// Apply shading effect
	base_color = apply_shade(base_color);

	// Apply damage effect
	apply_damage_fragment(base_color, UV);

	// Apply normal map with rotation
	base_color.rgb = apply_normal_map(UV, base_color.rgb, object_rotation);

	// Set final color
	COLOR = base_color;
}
