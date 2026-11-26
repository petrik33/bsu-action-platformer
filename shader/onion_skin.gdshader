shader_type canvas_item;
render_mode blend_mix;

// Ghost look. Every value is driven by OnionSkinTrail so the effect can be
// reused on any character without editing the shader.

// Colour of a freshly spawned ghost.
uniform vec4 tint : source_color = vec4(0.35, 0.75, 1.0, 1.0);
// Colour the ghost shifts toward as it fades out.
uniform vec4 fade_tint : source_color = vec4(0.10, 0.25, 0.85, 1.0);
// Base opacity of the ghost.
uniform float alpha : hint_range(0.0, 1.0) = 0.55;
// Lifetime multiplier driven by the trail (1 = fresh, 0 = gone).
uniform float fade : hint_range(0.0, 1.0) = 1.0;
// 0 = pure tinted silhouette, 1 = keep the sprite's own colours.
uniform float color_mix : hint_range(0.0, 1.0) = 0.0;
// Vertical brightness falloff (brighter at the top of the sprite).
uniform float gradient_strength : hint_range(0.0, 1.0) = 0.35;
// Subtle animated shimmer.
uniform float flicker : hint_range(0.0, 1.0) = 0.12;
uniform float flicker_speed = 30.0;
// Pixel dissolve as the ghost fades (0 = off).
uniform float dissolve : hint_range(0.0, 1.0) = 0.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (tex.a <= 0.001) {
		discard;
	}

	// Shift colour from the fresh tint toward the faded tint over the lifetime.
	vec3 ghost_color = mix(fade_tint.rgb, tint.rgb, fade);
	vec3 col = mix(ghost_color, tex.rgb * ghost_color, color_mix);

	// Brighter near the top of the sprite.
	col *= mix(1.0, 1.0 - gradient_strength, UV.y);

	// Animated shimmer.
	float flick = 1.0 - flicker * (0.5 + 0.5 * sin(TIME * flicker_speed + UV.y * 10.0));

	// Optional pixel dissolve tied to the fade.
	float dissolve_mask = 1.0;
	if (dissolve > 0.0) {
		float noise = hash(floor(UV * 64.0));
		dissolve_mask = step(noise, 1.0 - (1.0 - fade) * dissolve);
	}

	COLOR = vec4(col, tex.a * alpha * fade * flick * dissolve_mask);
}
