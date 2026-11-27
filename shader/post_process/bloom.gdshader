shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Cheap single-pass bloom
//
// 1. Threshold: keep only pixels brighter than `threshold`.
// 2. Blur: sample a ring of neighbours around each pixel.
// 3. Add: composite the blurred bright pass back over the original.
//
// Production bloom usually does the blur in two separable passes at half
// resolution (horizontal, then vertical) because a Gaussian is separable:
// G(x,y) = G(x) * G(y). This single-pass version trades quality for
// simplicity so the whole effect fits in one shader.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float threshold : hint_range(0.0, 1.0) = 0.6;
uniform float intensity : hint_range(0.0, 3.0) = 0.9;
uniform float radius : hint_range(0.0, 24.0) = 6.0;
uniform vec4 bloom_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 1.0;

const vec3 LUMA = vec3(0.2126, 0.7152, 0.0722);

float bright_mask(vec3 c) {
	return smoothstep(threshold, threshold + 0.15, dot(c, LUMA));
}

void fragment() {
	vec3 base = texture(screen_texture, SCREEN_UV).rgb;

	// Two rings of 8 samples give a smoother falloff than a single ring.
	vec3 glow = vec3(0.0);
	float weight_sum = 0.0;
	for (int ring = 0; ring < 2; ring++) {
		float ring_radius = radius * (ring == 0 ? 0.5 : 1.0);
		float ring_weight = ring == 0 ? 1.0 : 0.55;
		for (int i = 0; i < 8; i++) {
			float angle = (float(i) + float(ring) * 0.5) * 0.7853982;
			vec2 offset = vec2(cos(angle), sin(angle)) * ring_radius * SCREEN_PIXEL_SIZE;
			vec3 sample_col = texture(screen_texture, SCREEN_UV + offset).rgb;
			glow += sample_col * bright_mask(sample_col) * ring_weight;
			weight_sum += ring_weight;
		}
	}
	glow /= weight_sum;

	vec3 processed = base + glow * bloom_tint.rgb * intensity;
	COLOR = vec4(mix(base, processed, strength), 1.0);
}
