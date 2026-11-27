# Underwater

Sways the image and adds caustics and a blue tint.

## Math

- **Wave distortion**: two travelling sine waves displace the UVs:
  `offset.x = sin(uv.y * scale + t) * strength`.
- **Caustics**: a value-noise field, raised to a power, brightens the surface.
- **Tint**: mix toward a water colour.
- **Vignette**: radial darkening.

## Uniforms

- `wave_strength`, `wave_speed`, `wave_scale`
- `water_tint`, `tint_strength`
- `caustic_strength`, `caustic_scale`
- `strength` — blend with the original
