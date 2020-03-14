shader_type canvas_item;

uniform sampler2D city;
uniform sampler2D noise;


void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec4 displacerT = texture(noise,UV);
	float mixer = (displacerT.x + displacerT.y + displacerT.z)/3.;
	vec2 movement = vec2(sin(TIME*0.05),-cos(TIME*0.05));
	sprite_color = mix(sprite_color, texture(city, movement +(0.09+mixer*0.01)*UV),0.3*mixer*sprite_color.a);
	COLOR = sprite_color;
}