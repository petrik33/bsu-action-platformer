# Posterize + ordered dithering

Reduces each colour channel to a few levels and adds a Bayer threshold before
rounding, so the eye averages the dot pattern back into a smooth gradient.

## Math

Quantisation to `L` levels:

```
q(x) = round(x * (L - 1)) / (L - 1)
```

Ordered dithering adds a per-pixel threshold `d` from a 4x4 Bayer matrix:

```
q(x) = floor(x * (L - 1) + 0.5 + d) / (L - 1)
```

The 8x8 Bayer matrix is a recursive threshold map:

```
 0 32  8 40  2 34 10 42
48 16 56 24 50 18 58 26
12 44  4 36 14 46  6 38
60 28 52 20 62 30 54 22
 3 35 11 43  1 33  9 41
51 19 59 27 49 17 57 25
15 47  7 39 13 45  5 37
63 31 55 23 61 29 53 21
```

## Uniforms

- `levels` — shades per channel (2..16, default 6)
- `dither_strength` — 0 disables the pattern
- `pixel_size` — >1 makes chunky pixels
- `tint` — colour multiplier
- `strength` — blend with the original
