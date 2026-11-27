shader_type canvas_item;
render_mode unshaded;

// -----------------------------------------------------------------------------
// Damage vignette
//
// A red radial falloff that darkens the edges of the screen. Drive `strength`
// from 0 to 1 on hit and let it decay; PostProcess.pulse() does that for you.
//
// Math: distance from the centre is normalised so the corners are 1.0, then a
// smoothstep turns that into a soft ring mask.
// -----------------------------------------------------------------------------

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 damage_color : source_color = vec4(0.75, 0.05, 0.05, 1.0);
uniform float inner_radius : hint_range(0.0, 1.0) = 0.35;
uniform float outer_radius : hint_range(0.0, 1.5) = 0.9;

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;
	vec2 centered = SCREEN_UV - 0.5;
	float dist = length(centered) * 1.41421356;
	float mask = smoothstep(inner_radius, outer_radius, dist);
	COLOR = vec4(mix(original, damage_color.rgb, mask * strength), 1.0);
}
