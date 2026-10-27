shader_type canvas_item;

// Driven by the Tween in GDScript from 0.0 to 1.0
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// Aesthetic customization
uniform vec4 blood_tint : source_color = vec4(0.85, 0.02, 0.02, 1.0);
uniform float drip_intensity : hint_range(0.0, 0.3) = 0.08;
uniform float pulse_speed = 18.0;
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.35;

// Pseudo-random noise helper
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;

    // --- Stage 3: Melt & Drip Downwards ---
    float drip_phase = smoothstep(0.65, 1.0, progress);
    float drip_distortion = sin(uv.x * 35.0) * cos(uv.x * 70.0 + progress * 4.0);
    uv.y -= drip_distortion * drip_intensity * drip_phase;

    // --- Stage 2: Adrenaline Tremble ---
    float active_phase = smoothstep(0.15, 0.35, progress) * (1.0 - smoothstep(0.75, 0.95, progress));
    float shake = sin(progress * pulse_speed * 6.28318) * 0.005 * active_phase;
    uv.x += shake;

    vec4 tex = texture(TEXTURE, uv);

    // --- Stage 1: Seep / Bleed Wipe Reveal ---
    float organic_mask = hash(uv * 18.0) * 0.15;
    float reveal = smoothstep(0.0, 0.25, progress + organic_mask);
    float dissolve = 1.0 - smoothstep(0.75, 1.0, progress);

    // Dynamic emissive pulse
    float pulse = 1.0 + sin(progress * pulse_speed * 6.28318) * pulse_intensity * active_phase;
    vec3 col = mix(tex.rgb, blood_tint.rgb, 0.45) * pulse;

    COLOR = vec4(col, tex.a * reveal * dissolve);
}