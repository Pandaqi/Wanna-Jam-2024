shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float speed = 0.5;

void fragment() 
{
	vec2 uv = UV;
	float dist_to_center_raw = length( uv - vec2(0.5, 0.5) );
	float dist_to_center = dist_to_center_raw;
	dist_to_center -= (TIME*speed) - floor(TIME*speed);
	float noise = 0.2*texture(noise_tex, SCREEN_UV).r;
	float alpha = 0.0; 
	if(abs(dist_to_center - noise) <= 0.5 && abs(dist_to_center - noise) >= 0.45)
	{
		alpha = 1.0;
	}
	alpha *= pow(0.5 - dist_to_center_raw, 0.5);
	COLOR = vec4(1,1,1,alpha);	
}