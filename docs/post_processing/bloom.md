# Bloom

Bright pixels bleed light into their neighbours.

## Math

1. Threshold by luminance: `L = 0.2126 R + 0.7152 G + 0.0722 B`.
2. Blur the bright pass.
3. Add it back: `out = base + glow * intensity`.

A Gaussian blur is separable: `G(x, y) = G(x) * G(y)`, so production bloom does
two 1D passes at half resolution. This shader approximates it with two rings of
8 samples in one pass.

## Uniforms

- `threshold` — luminance cutoff
- `intensity` — glow strength
- `radius` — blur radius in pixels
- `bloom_tint` — glow colour
- `strength` — blend with the original
