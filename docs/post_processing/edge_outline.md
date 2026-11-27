# Sobel outline

Draws dark lines on silhouettes.

## Math

The Sobel operator estimates the image gradient with two 3x3 convolution
kernels:

```
Gx = [-1 0 1]      Gy = [-1 -2 -1]
     [-2 0 2]           [ 0  0  0]
     [-1 0 1]           [ 1  2  1]
```

The gradient magnitude `sqrt(Gx² + Gy²)` is large where the image changes
quickly, i.e. on edges. Pixels above `threshold` get the outline colour.

## Uniforms

- `thickness` — sample distance in pixels
- `threshold` — edge sensitivity
- `outline_color`
- `mix_amount` — outline opacity
- `strength` — blend with the original
