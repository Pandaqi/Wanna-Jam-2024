shader_type canvas_item;

uniform vec4 color : source_color = vec4(1,0,0,1);
uniform sampler2D noise_tex;
uniform float threshold = 0.33;

void fragment() {
	float noise = texture(noise_tex, UV).r;
	float dist_to_edge = min(UV.y, 1.0 - UV.y);
	COLOR.rgb = color.rgb;
	COLOR.a = 0.0;
	if(dist_to_edge <= threshold)
	{
		COLOR.a = mix(noise, 0.0, dist_to_edge / threshold);
	}
	
	
}
