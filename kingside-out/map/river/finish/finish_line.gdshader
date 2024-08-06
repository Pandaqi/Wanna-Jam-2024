shader_type canvas_item;
render_mode blend_add;

uniform vec4 block_color : source_color = vec4(1,1,1,1);
uniform vec4 gap_color : source_color = vec4(1,1,1,0.2);
uniform vec2 sprite_size = vec2(128.0);
uniform float scale = 1.0;

void fragment() {
	vec2 world_pos = UV * sprite_size;
	float factor = floor(world_pos.x / scale) + floor(world_pos.y / scale);
    // divide it by 2 and get the fractional part, resulting in a value of 0 for even and 0.5 for odd numbers.
    // then multiply it by 2 to get 0 for even and 1 for odd
	factor = fract(factor * 0.5);
    COLOR = mix(gap_color, block_color, factor);
}
