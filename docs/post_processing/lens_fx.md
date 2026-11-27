# Lens FX

Chromatic aberration, vignette, film grain, and optional scanlines.

## Math

- **Chromatic aberration**: sample R outward and B inward along the radial
  direction, scaled by the squared distance from the centre:
  `shift = (uv - 0.5) * aberration * r²`.
- **Vignette**: multiply by a smooth radial falloff.
- **Grain**: add a per-pixel hash that changes every frame.
- **Scanlines**: `sin(uv.y * count)` darkens alternate rows.

## Uniforms

- `aberration` — channel split at the edges
- `vignette_strength`, `vignette_softness`
- `grain` — noise amount
- `scanline_strength`, `scanline_count`
- `strength` — blend with the original
