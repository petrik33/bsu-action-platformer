shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Underwater
//
// Two travelling sine waves displace the screen UVs, which makes the whole
// image sway. A cheap value-noise field adds animated caustics, and a blue
// tint plus a vignette sell the depth.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float wave_strength : hint_range(0.0, 0.02) = 0.004;
uniform float wave_speed : hint_range(0.0, 4.0) = 1.2;
uniform float wave_scale : hint_range(1.0, 40.0) = 12.0;
uniform vec4 water_tint : source_color = vec4(0.25, 0.55, 0.85, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.35;
uniform float caustic_strength : hint_range(0.0, 1.0) = 0.25;
uniform float caustic_scale : hint_range(1.0, 20.0) = 6.0;
uniform float strength : hint_range(0.0, 1.0) = 1.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;

	vec2 uv = SCREEN_UV;
	float t = TIME * wave_speed;

	vec2 offset;
	offset.x = sin(uv.y * wave_scale + t) * wave_strength;
	offset.y = cos(uv.x * wave_scale * 0.7 + t * 1.3) * wave_strength * 0.6;

	vec3 col = texture(screen_texture, uv + offset).rgb;

	float caustic = pow(noise(uv * caustic_scale + vec2(t * 0.3, t * 0.2)), 3.0);
	col += caustic * caustic_strength * water_tint.rgb;

	col = mix(col, water_tint.rgb, tint_strength);

	vec2 d = uv - 0.5;
	col *= 1.0 - dot(d, d) * 0.8;

	COLOR = vec4(mix(original, col, strength), 1.0);
}
