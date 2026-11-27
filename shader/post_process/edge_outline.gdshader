shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Sobel edge outline
//
// The Sobel operator estimates the image gradient with two 3x3 convolution
// kernels (one for horizontal change, one for vertical). The gradient
// magnitude sqrt(gx^2 + gy^2) is large where the image changes quickly, i.e.
// on silhouettes. We draw those pixels in `outline_color`.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float thickness : hint_range(1.0, 4.0) = 1.0;
uniform float threshold : hint_range(0.0, 1.0) = 0.15;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float mix_amount : hint_range(0.0, 1.0) = 1.0;
uniform float strength : hint_range(0.0, 1.0) = 1.0;

float luma(vec3 c) {
	return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;

	vec2 px = SCREEN_PIXEL_SIZE * thickness;
	vec2 uv = SCREEN_UV;

	float tl = luma(texture(screen_texture, uv + px * vec2(-1.0, -1.0)).rgb);
	float t  = luma(texture(screen_texture, uv + px * vec2( 0.0, -1.0)).rgb);
	float tr = luma(texture(screen_texture, uv + px * vec2( 1.0, -1.0)).rgb);
	float l  = luma(texture(screen_texture, uv + px * vec2(-1.0,  0.0)).rgb);
	float r  = luma(texture(screen_texture, uv + px * vec2( 1.0,  0.0)).rgb);
	float bl = luma(texture(screen_texture, uv + px * vec2(-1.0,  1.0)).rgb);
	float b  = luma(texture(screen_texture, uv + px * vec2( 0.0,  1.0)).rgb);
	float br = luma(texture(screen_texture, uv + px * vec2( 1.0,  1.0)).rgb);

	float gx = -tl - 2.0 * l - bl + tr + 2.0 * r + br;
	float gy = -tl - 2.0 * t - tr + bl + 2.0 * b + br;
	float edge = smoothstep(threshold, threshold + 0.1, sqrt(gx * gx + gy * gy));

	vec3 processed = mix(original, outline_color.rgb, edge * mix_amount);
	COLOR = vec4(mix(original, processed, strength), 1.0);
}
