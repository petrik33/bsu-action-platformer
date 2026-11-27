shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// CRT monitor
//
// Barrel distortion: push each pixel away from the centre by an amount that
// grows with the squared radius, which bends straight lines into a tube.
// Scanlines: a high-frequency sine darkens every other row.
// Aperture grille: alternate RGB columns, like a real shadow mask.
//
// `strength` blends the result with the untouched screen so the effect can fade.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float curvature : hint_range(0.0, 0.4) = 0.12;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.35;
uniform float grille_strength : hint_range(0.0, 1.0) = 0.15;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.5;
uniform float brightness : hint_range(0.5, 2.0) = 1.15;
uniform float strength : hint_range(0.0, 1.0) = 1.0;

vec2 barrel(vec2 uv, float k) {
	vec2 c = uv * 2.0 - 1.0;
	c *= 1.0 + k * dot(c, c);
	return c * 0.5 + 0.5;
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;
	vec2 uv = barrel(SCREEN_UV, curvature);

	vec3 col;
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		col = vec3(0.0);
	} else {
		col = texture(screen_texture, uv).rgb * brightness;

		float scan = 0.5 + 0.5 * sin(uv.y * 360.0 * 6.2831853);
		col *= 1.0 - scanline_strength * (1.0 - scan);

		float column = mod(floor(uv.x / SCREEN_PIXEL_SIZE.x), 3.0);
		vec3 grille = column < 1.0 ? vec3(1.0, 0.85, 0.85)
					: column < 2.0 ? vec3(0.85, 1.0, 0.85)
					               : vec3(0.85, 0.85, 1.0);
		col = mix(col, col * grille, grille_strength);

		vec2 c = uv - 0.5;
		col *= 1.0 - vignette_strength * dot(c, c) * 2.0;
	}

	COLOR = vec4(mix(original, col, strength), 1.0);
}
