# Damage vignette

A red radial falloff that flashes when the player is hit.

## Math

Normalise the distance from the centre so the corners are 1.0:

```
dist = length(uv - 0.5) * sqrt(2)
```

Then a smoothstep turns that into a soft ring mask:

```
mask = smoothstep(inner_radius, outer_radius, dist)
out = mix(original, damage_color, mask * strength)
```

`GameFx.pulse()` drives `strength` from 0 up to a peak and back.

## Uniforms

- `strength` — 0..1, driven by `GameFx`
- `damage_color`
- `inner_radius`, `outer_radius`
