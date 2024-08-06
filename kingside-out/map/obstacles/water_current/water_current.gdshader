shader_type canvas_item;
render_mode blend_add;

uniform sampler2D arrow_tex;
uniform float scale = 1.0;
uniform float scroll_speed = 1.0;

void fragment() 
{
	float uv_y = UV.y * scale;
	float uv_y_mod = uv_y - floor(uv_y);
	bool alternating_row = int(floor(uv_y)) % 2 == 0;

	float uv_x = (UV.x - TIME*scroll_speed) * scale;
	if(alternating_row) { uv_x += 0.5; }
	float uv_x_mod = uv_x - floor(uv_x);
	
	vec2 uv = vec2(uv_x_mod, uv_y_mod);
	float dist_from_center = distance(UV, vec2(0.5, 0.5));
	COLOR = texture(arrow_tex, uv);
	COLOR.r = 0.0;
	COLOR.a *= 0.5 - dist_from_center;
}

