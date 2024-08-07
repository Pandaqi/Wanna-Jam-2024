shader_type canvas_item;

uniform vec4 color : source_color;
uniform sampler2D noise_tex;

void fragment() {
	float noise = texture(noise_tex, UV).r;
	COLOR = color + 0.1*noise; 
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
