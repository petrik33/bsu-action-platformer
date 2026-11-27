shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Lens FX: chromatic aberration + vignette + film grain + optional scanlines
//
// Chromatic aberration: real lenses bend different wavelengths by different
// amounts, so R/G/B separate toward the edges. We fake it by sampling the red
// channel slightly outward and the blue channel slightly inward, scaled by the
// squared distance from the centre.
//
// Vignette: multiply by a smooth radial falloff.
// Grain: add a per-pixel hash value that changes every frame.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float aberration : hint_range(0.0, 8.0) = 1.5;
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.6;
uniform float vignette_softness : hint_range(0.1, 2.0) = 0.8;
uniform float grain : hint_range(0.0, 0.5) = 0.06;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.0;
uniform float scanline_count = 180.0;
uniform float strength : hint_range(0.0, 1.0) = 1.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;

	vec2 uv = SCREEN_UV;
	vec2 centered = uv - 0.5;
	float r2 = dot(centered, centered);

	// Split the channels radially.
	vec2 shift = centered * aberration * SCREEN_PIXEL_SIZE * 2.0 * r2;
	float red = texture(screen_texture, uv + shift).r;
	float green = texture(screen_texture, uv).g;
	float blue = texture(screen_texture, uv - shift).b;
	vec3 col = vec3(red, green, blue);

	// Vignette: 1 in the centre, 0 at the corners.
	float vig = smoothstep(0.9, 0.9 - vignette_softness, r2 * 2.0);
	col *= mix(1.0, vig, vignette_strength);

	// Scanlines.
	float scan = 0.5 + 0.5 * sin(uv.y * scanline_count * 6.2831853);
	col *= 1.0 - scanline_strength * (1.0 - scan);

	// Animated grain.
	float n = hash(uv * vec2(1920.0, 1080.0) + fract(TIME) * 100.0);
	col += (n - 0.5) * grain;

	COLOR = vec4(mix(original, col, strength), 1.0);
}
