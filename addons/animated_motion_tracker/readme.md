# Animated Motion Tracker for Godot 4

An in-editor utility node that tracks pixel features across `AnimatedSprite2D` frames and automatically generates discrete position keyframes inside an `AnimationPlayer` track.

Use it to automatically track:
- Weapon attachment points and hand anchors.
- Foot-planting / horizontal root-motion shifts baked into sprite sheets.
- Particle FX spawn points (muzzle flashes, dust, spell origins).

> **Note on Tracking Precision:** Because sprite animations often feature sudden perspective shifts, sub-pixel rendering, or color pooling, pixel tracking can occasionally drift by a few pixels on extreme frames. This tool is designed to eliminate 90% of the manual labor: click generate to get the baseline trajectory, then nudge the few stray frames into place manually.

---

## Installation

1. Download the `addons/animated_motion_tracker` folder.
2. Drop it into your Godot project's `res://addons/` directory.
3. Open **Project Settings > Plugins** and enable **Animated Motion Tracker**.

---

## Quickstart

1. Add an `AnimatedMotionTrackerTool` node to your scene (typically as a temporary child or sibling of your character).
2. Assign the target references in the Inspector:
   - **Anim Player:** Your character's `AnimationPlayer`.
   - **Sprite:** The `AnimatedSprite2D` containing the animation.
   - **Tracker:** The `Node2D` you want to follow the sprite feature (e.g., a `Marker2D` for weapon grip or root).
3. Set **Sprite Anim Name** and **Anim Player Anim Name** to the target animation.
4. In the 2D viewport, scrub to the starting frame and position your **Tracker** directly over the feature you want to follow (e.g., the character's hand).
5. Click **Generate Track** in the Inspector.
6. Check your `AnimationPlayer`—a `:position` track for your tracker node is now populated with keyframes on every sprite frame change.

---

## Inspector Parameters

### Target Nodes
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `anim_player` | `AnimationPlayer` | The player containing the target timeline to keyframe. |
| `sprite` | `AnimatedSprite2D` | The sprite driving the visual frames. |
| `tracker` | `Node2D` | The node whose position will be keyframed. |

### Animation Settings
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `sprite_anim_name` | `String` | Animation name inside the `SpriteFrames` resource. |
| `anim_player_anim_name` | `String` | Target animation name inside the `AnimationPlayer`. |

### Alignment Mode
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `lock_y` | `bool` | Locks vertical tracking to the tracker's initial Y coordinate. Restricts the search space to a 1D horizontal line. Ideal for horizontal ground-sliding root motion. |

### Feature Tracking
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `enable_pixel_tracking` | `bool` | When `true`, matches RGB colors within a local patch. When `false`, tracks purely based on the sprite's bounding box (`get_used_rect()`). |
| `update_patch_per_frame` | `bool` | When `true`, updates the reference color patch to the found position on every frame (best for rotating limbs or dynamic lighting). When `false`, strictly tracks the original frame's colors (best for static-colored markers). |
| `search_radius` | `int (2–64)` | The maximum distance (in pixels) the algorithm scans around the last known position. Increase for fast, jerky movements; decrease for slow motion or noisy sprites. |
| `patch_size` | `int (1–15)` | Width/height of the square pixel patch sampled for matching. Odd numbers (e.g., `3`, `5`) center cleanly on a pixel. |

---

## Troubleshooting

- **Configuration Warnings:** Check the yellow warning icon next to the node in your Scene tree. The tool requires valid references and an existing `:frame` track in the `AnimationPlayer` to determine frame timings.
- **Drifting Tracks:** If tracking loses the target, try increasing `patch_size` to give the matcher more surrounding context, or disable `update_patch_per_frame` if color drift is causing error accumulation.
