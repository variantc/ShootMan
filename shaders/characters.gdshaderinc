
void breath(inout vec2 vertex, float f){
	float m = 0.02;
	float breath_anim = m * sin(f * TIME);
	vertex *= 1.0 + breath_anim;
}


group_uniforms flash;
uniform float mix_amount : hint_range(0.0, 0.8);
uniform vec3 flash_colour : source_color;
group_uniforms;

void flash_on_hit(inout vec3 c) {
	c = mix(c, flash_colour, mix_amount);
}