# Post-processing in Godot

Screen-space effects for the course. Each effect is a `canvas_item` shader on a
full-screen `ColorRect` that samples the framebuffer. Effects are stacked as
separate `CanvasLayer`s, one per pass.

## How it works

### 1. The 2D render pipeline

Godot draws every visible `CanvasItem` (sprites, tilemaps, `ColorRect`s) into the
viewport framebuffer. A `CanvasLayer` is a separate canvas with its own draw
order (`layer` property). Layers draw in ascending order, so layer 100 draws
after the game world on layer 0.

### 2. Why a CanvasLayer?

- It draws after the game world, so the effect sees the finished frame.
- It ignores the `Camera2D` transform, so the overlay stays screen-aligned.
- **Godot refreshes the screen texture between canvas layers.** That is what
  makes stacking work: each effect layer reads the output of the previous one.
  Inside a single layer, all screen-reading items see the same texture, so
  effects must live in separate layers.
- A `Control` directly under a `CanvasLayer` uses the viewport rect as its
  parent, so full-rect anchors cover the screen.

### 3. Reaching the framebuffer

Declare a screen-texture sampler:

```glsl
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
```

Then read it in `fragment()`:

```glsl
vec3 original = texture(screen_texture, SCREEN_UV).rgb;
```

- `SCREEN_UV` is the normalized screen coordinate (0..1).
- `SCREEN_PIXEL_SIZE` is `1.0 / viewport_size`, used for pixel-sized offsets.
- The screen texture is a copy of the framebuffer taken when the item is drawn.
  Godot manages the copy (the "back buffer"); you do not create it manually.

### 4. Selecting the material

A `ShaderMaterial` holds a `Shader` resource and its uniform values:

```gdscript
var material := ShaderMaterial.new()
material.shader = load("res://shader/post_process/bloom.gdshader")
material.set_shader_parameter("intensity", 1.2)
rect.material = material
```

`PostProcessEffect` exports the `ShaderMaterial` directly, so you can tune every
uniform per scene in the inspector. The ready-made scenes in
`scene/post_processing/` already contain an inline `ShaderMaterial` with the
right shader assigned.

### 5. The full-screen ColorRect

`ColorRect` is a `Control` that draws a rectangle. With a `ShaderMaterial`, the
fragment shader replaces the colour. It needs:

- full-rect anchors so it covers the viewport,
- `mouse_filter = Ignore` so it does not eat input.

The rect's own colour is irrelevant because the shader writes `COLOR`.

`PostProcessEffect` creates this `ColorRect` at runtime instead of storing it in
the scene. That keeps the editor clean: you only see the `CanvasLayer` node and
its exported `material`, not a giant rectangle covering the level. If no
material is assigned, no rect is created. The effect still previews when you run
the game.

### 6. Stacking

Each effect is one `PostProcessEffect` (a `CanvasLayer` + runtime `ColorRect` +
`ShaderMaterial`). Put them under a `PostProcessing` node:

```
Game
└── PostProcessing
    ├── Posterize   (PostProcessEffect)
    ├── Bloom       (PostProcessEffect)
    └── CRT         (PostProcessEffect)
```

`PostProcessing` assigns `layer = base_layer + index` in tree order, so the tree
order is the execution order. Reorder the children in the editor to reorder the
effects.

### 7. The `strength` uniform

Every shader blends the result with the untouched screen:

```glsl
COLOR = vec4(mix(original, processed, strength), 1.0);
```

`strength = 0` is the original image, `1` is the full effect. This lets you fade
effects in/out or fire one-shot pulses.

### 8. Animation lives in GameFx

`PostProcessEffect` only stores state (`shader`, `strength`, `enabled`). The
`GameFx` node owns the tweens:

```gdscript
fx.fade(effect, 1.0, 0.6)   # animate strength to 1.0 over 0.6s
fx.pulse(effect, 0.9, 0.35) # ramp up to 0.9, then back to 0
```

This keeps effects dumb and puts all timing in one place.

### 9. Layer order and the HUD

```
layer 0        game world
layer 100..N   post-process effects (base_layer + index)
layer 200      HUD (above every effect)
```

Keep the HUD above the highest effect layer, otherwise it gets processed too.

### 10. Performance

Each effect is a full-screen pass plus a screen-texture copy. N effects cost N
passes. Keep the stack short, and merge effects that always run together into a
single shader when you can.

### 11. Renderer note

The project uses the GL Compatibility renderer, which does not support
`WorldEnvironment` glow/bloom. Screen-space shaders work on every renderer.

## Effects

| Shader | Docs |
| --- | --- |
| `posterize_dither.gdshader` | [posterize_dither.md](posterize_dither.md) |
| `bloom.gdshader` | [bloom.md](bloom.md) |
| `lens_fx.gdshader` | [lens_fx.md](lens_fx.md) |
| `crt.gdshader` | [crt.md](crt.md) |
| `edge_outline.gdshader` | [edge_outline.md](edge_outline.md) |
| `underwater.gdshader` | [underwater.md](underwater.md) |
| `damage_vignette.gdshader` | [damage_vignette.md](damage_vignette.md) |

## Adding an effect

1. Add a `PostProcessEffect` node under `PostProcessing` (Add Node), or instance
   one of the ready-made scenes in `scene/post_processing/`.
2. Assign a `ShaderMaterial` in the inspector (the ready-made scenes already do).
3. Tune the shader uniforms on the material, including `strength` (0 = off,
   1 = full).
4. Reorder the child to change its place in the stack.

The effect node is just a `CanvasLayer`; its full-screen `ColorRect` is built at
runtime, so nothing large appears in the editor viewport.

## Driving effects from gameplay

`script/game_fx.gd` owns the animation. Example:

```gdscript
func enter_water() -> void:
    fade(underwater, 1.0, 0.6)

func exit_water() -> void:
    fade(underwater, 0.0, 0.6)
```

## API reference

`PostProcessEffect` (`script/post_processing/post_process_effect.gd`):

| Method / property | Purpose |
| --- | --- |
| `material` | The `ShaderMaterial` to run (inspector) |
| `strength` | 0..1 blend, reads/writes the material's `strength` uniform |
| `set_param(name, value)` | Set any uniform on the active material |
| `set_strength(value)` | Set the blend directly |
| `get_strength()` | Read the current blend |

`PostProcessing` (`script/post_processing/post_processing.gd`):

| Property | Purpose |
| --- | --- |
| `base_layer` | Layer number of the first effect (default 100) |

`GameFx` (`script/game_fx.gd`):

| Method | Purpose |
| --- | --- |
| `fade(effect, value, duration)` | Animate an effect's strength |
| `pulse(effect, peak, duration)` | One-shot ramp up and back to 0 |
