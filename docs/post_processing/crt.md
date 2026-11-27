# CRT

Barrel distortion, scanlines, and an aperture grille.

## Math

- **Barrel distortion**: push pixels away from the centre by an amount that
  grows with the squared radius: `c *= 1 + k * dot(c, c)`.
- **Scanlines**: a high-frequency sine darkens alternate rows.
- **Aperture grille**: alternate RGB columns, like a shadow mask.
- **Vignette**: radial darkening.

## Uniforms

- `curvature` — barrel amount
- `scanline_strength`
- `grille_strength`
- `vignette_strength`
- `brightness`
- `strength` — blend with the original
