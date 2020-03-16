shader_type canvas_item;

uniform sampler2D city;
uniform sampler2D noise;


void fragment() {
	vec4 sprite_color = texture(TEXTURE, (sin(TIME*3.)*0.5)*vec2(0.,0.2)+(UV-0.5)+0.5);
	COLOR = sprite_color;
}