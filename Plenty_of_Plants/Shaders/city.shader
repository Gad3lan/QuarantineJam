shader_type canvas_item;

uniform sampler2D city;
uniform sampler2D noise;


void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec2 movement = vec2(sin(TIME*0.05),-cos(TIME*0.05));
	vec4 displacerT = texture(noise,-movement + vec2(SCREEN_UV.x,-SCREEN_UV.y));
	float mixer = pow((displacerT.x + displacerT.y + displacerT.z)/3.,2.7);
	sprite_color = mix(sprite_color, texture(city, movement +(0.3+mixer*0.05)*vec2(SCREEN_UV.x*2.,-SCREEN_UV.y*2.)),mixer*sprite_color.a*(2.-3.*sprite_color.r));
	displacerT = vec4(mixer*sprite_color.a,mixer*sprite_color.a,mixer*sprite_color.a,1.);
	COLOR = sprite_color;
}