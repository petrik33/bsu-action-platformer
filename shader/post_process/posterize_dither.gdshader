shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Posterize + ordered dithering
//
// Idea: reduce each colour channel to a small number of levels, then add a
// per-pixel threshold from a Bayer matrix before rounding. The eye averages the
// resulting dot pattern back into a smooth gradient, so a 6-level image can
// still read as a continuous one.
//
// Math: quantise(x) = round(x * (L-1) + d) / (L-1), where d is the Bayer
// threshold in [-0.5, 0.5]. The Bayer matrix is a recursive threshold map.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform int levels : hint_range(2, 16) = 6;
uniform float dither_strength : hint_range(0.0, 1.0) = 1.0;
uniform float pixel_size : hint_range(1.0, 8.0) = 1.0;
uniform vec4 tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 1.0;

// Standard 8x8 Bayer matrix, normalised to 0..1.
const float BAYER[64] = float[64](
	 0.0, 32.0,  8.0, 40.0,  2.0, 34.0, 10.0, 42.0,
	48.0, 16.0, 56.0, 24.0, 50.0, 18.0, 58.0, 26.0,
	12.0, 44.0,  4.0, 36.0, 14.0, 46.0,  6.0, 38.0,
	60.0, 28.0, 52.0, 20.0, 62.0, 30.0, 54.0, 22.0,
	 3.0, 35.0, 11.0, 43.0,  1.0, 33.0,  9.0, 41.0,
	51.0, 19.0, 59.0, 27.0, 49.0, 17.0, 57.0, 25.0,
	15.0, 47.0,  7.0, 39.0, 13.0, 45.0,  5.0, 37.0,
	63.0, 31.0, 55.0, 23.0, 61.0, 29.0, 53.0, 21.0
);

float bayer8(vec2 pixel) {
	ivec2 p = ivec2(mod(pixel, 8.0));
	return BAYER[p.y * 8 + p.x] / 64.0;
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;

	vec2 uv = SCREEN_UV;
	if (pixel_size > 1.0) {
		vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
		uv = (floor(uv * res / pixel_size) + 0.5) * pixel_size / res;
	}

	vec3 col = texture(screen_texture, uv).rgb * tint.rgb;

	// Bayer threshold in [-0.5, 0.5], scaled by strength.
	float d = (bayer8(floor(FRAGCOORD.xy / pixel_size)) - 0.5) * dither_strength;
	float steps = float(levels - 1);
	col = floor(col * steps + 0.5 + d) / steps;

	COLOR = vec4(mix(original, clamp(col, 0.0, 1.0), strength), 1.0);
}
