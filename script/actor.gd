class_name Actor extends CharacterBody2D

@export var visuals: Node2D
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var origin: Node2D
@export var animation_chain: AnimationChainPlayer

var current_animation: StringName = &""


func _enter_tree() -> void:
	if animation_chain and not animation_chain.animation_requested.is_connected(_play_single):
		animation_chain.animation_requested.connect(_play_single)

func face_movement():
	face(velocity.x)

func face_vector(direction: Vector2):
	face(direction.x)

func face(direction: float):
	if is_zero_approx(direction):
		return
	if is_equal_approx(facing_direction(), signf(direction)):
		return
	if origin == null:
		visuals.scale.x = signf(direction)
		return

	var offset_x = origin.position.x
	if direction > 0:
		visuals.scale.x = 1.0
		visuals.position.x = 0.0
	else:
		visuals.scale.x = -1.0
		visuals.position.x = 2.0 * offset_x

func facing_direction() -> float:
	return sign(visuals.scale.x)

func facing_vector() -> Vector2:
	return Vector2(facing_direction(), 0.0)

func get_current_animation() -> StringName:
	return current_animation

func turn_around():
	face(-facing_direction())

func play_animation(anim_name: StringName, time: float = -1.0, restart: bool = false):
	if current_animation == anim_name and not restart:
		return
	
	current_animation = anim_name
	sprite.stop()
	
	if animation_chain and animation_chain.has_chain(anim_name):
		animation_chain.play(anim_name, time)
		return
		
	_play_single(anim_name, time)

func stop_animation():
	current_animation = &""
	if animation_chain:
		animation_chain.stop()
	if animation_player and animation_player.is_playing():
		animation_player.stop()
		return
	if sprite.is_playing():
		sprite.stop()

func reset_animation_player():
	if not animation_player:
		return

	animation_player.play(&"RESET")
	animation_player.advance(0)
	animation_player.stop()


func _play_single(anim_name: StringName, time: float):
	if animation_player and animation_player.has_animation(anim_name):
		var animation_speed := Utils.get_anim_player_target_speed(
			animation_player, anim_name, time
		)
		animation_player.play(anim_name, -1, animation_speed)
		return
	if sprite.sprite_frames.has_animation(anim_name):
		reset_animation_player()
		var animation_speed := Utils.get_sprite_animation_target_speed(
			sprite, anim_name, time
		)
		sprite.play(anim_name, animation_speed)


## Time (seconds from the animation start) at which `frame` is reached.
## Returns -1.0 when the animation or frame cannot be resolved.
func get_frame_time(anim_name: StringName, frame: int, time: float = -1.0) -> float:
	return get_frame_window(anim_name, frame, time).x

## Time (seconds from the animation start) at which `frame` is exited, i.e.
## the next frame is reached. Returns -1.0 when it cannot be resolved.
func get_frame_exit_time(anim_name: StringName, frame: int, time: float = -1.0) -> float:
	return get_frame_window(anim_name, frame, time).y

## Returns (enter_time, exit_time) in seconds from the start of `anim_name` for
## `frame`, scaled so the animation lasts `time` seconds (natural length when
## `time <= 0`). Negative frames resolve from the end (-1 = last frame).
## Returns (-1, -1) when the animation, frame or track cannot be resolved.
## Animation chains are not supported.
func get_frame_window(anim_name: StringName, frame: int, time: float = -1.0) -> Vector2:
	if animation_chain and animation_chain.has_chain(anim_name):
		return Vector2(-1.0, -1.0)
	if animation_player and animation_player.has_animation(anim_name):
		return _get_anim_player_frame_window(anim_name, frame, time)
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		return _get_sprite_frame_window(anim_name, frame, time)
	return Vector2(-1.0, -1.0)


func _get_sprite_frame_window(anim_name: StringName, frame: int, time: float) -> Vector2:
	var frames := sprite.sprite_frames
	var frame_count := frames.get_frame_count(anim_name)
	var resolved := _resolve_frame(frame, frame_count)
	if resolved < 0:
		return Vector2(-1.0, -1.0)

	var fps := frames.get_animation_speed(anim_name)
	if is_zero_approx(fps):
		return Vector2(-1.0, -1.0)

	var speed := Utils.get_sprite_animation_target_speed(sprite, anim_name, time)
	var frame_scale := fps * speed
	var enter := 0.0
	for i in range(resolved):
		enter += frames.get_frame_duration(anim_name, i)
	var exit := enter + frames.get_frame_duration(anim_name, resolved)
	return Vector2(enter / frame_scale, exit / frame_scale)


func _get_anim_player_frame_window(anim_name: StringName, frame: int, time: float) -> Vector2:
	var anim := animation_player.get_animation(anim_name)
	if anim == null:
		return Vector2(-1.0, -1.0)

	var track := _find_sprite_track(anim, &"frame")
	if track < 0:
		return Vector2(-1.0, -1.0)

	var frame_count := _get_anim_frame_count(anim, track)
	var resolved := _resolve_frame(frame, frame_count)
	if resolved < 0:
		return Vector2(-1.0, -1.0)

	var window := _invert_frame_track(anim, track, resolved)
	if window.x < 0.0:
		return Vector2(-1.0, -1.0)

	var speed := Utils.get_anim_player_target_speed(animation_player, anim_name, time)
	return window / speed


func _resolve_frame(frame: int, frame_count: int) -> int:
	if frame_count <= 0:
		return -1
	var resolved := frame if frame >= 0 else frame_count + frame
	if resolved < 0 or resolved >= frame_count:
		return -1
	return resolved


func _find_sprite_track(anim: Animation, subname: StringName) -> int:
	var root := _get_animation_root()
	if root == null or sprite == null:
		return -1
	var sprite_names := root.get_path_to(sprite).get_concatenated_names()
	for i in range(anim.get_track_count()):
		if anim.track_get_type(i) != Animation.TYPE_VALUE:
			continue
		var path := anim.track_get_path(i)
		if path.get_subname(0) != subname:
			continue
		if path.get_concatenated_names() == sprite_names:
			return i
	return -1


func _get_animation_root() -> Node:
	if animation_player == null:
		return null
	if animation_player.root_node.is_empty():
		return animation_player.get_parent()
	return animation_player.get_node_or_null(animation_player.root_node)


func _get_anim_frame_count(anim: Animation, frame_track: int) -> int:
	var anim_track := _find_sprite_track(anim, &"animation")
	if anim_track >= 0 and anim.track_get_key_count(anim_track) > 0:
		var sprite_anim: StringName = anim.track_get_key_value(anim_track, 0)
		if sprite.sprite_frames and sprite.sprite_frames.has_animation(sprite_anim):
			return sprite.sprite_frames.get_frame_count(sprite_anim)
	var key_count := anim.track_get_key_count(frame_track)
	if key_count > 0:
		return int(float(anim.track_get_key_value(frame_track, key_count - 1))) + 1
	return 0


func _invert_frame_track(anim: Animation, track: int, target: int) -> Vector2:
	var key_count := anim.track_get_key_count(track)
	if key_count < 2:
		return Vector2(-1.0, -1.0)

	var times := PackedFloat32Array()
	var values := []
	for i in range(key_count):
		times.append(anim.track_get_key_time(track, i))
		values.append(float(anim.track_get_key_value(track, i)))

	var direction := 0
	for i in range(key_count - 1):
		var v0: float = values[i]
		var v1: float = values[i + 1]
		if is_equal_approx(v0, v1):
			continue
		direction = 1 if v1 > v0 else -1
		break
	if direction == 0:
		return Vector2(-1.0, -1.0)

	var enter_threshold := float(target) if direction > 0 else float(target + 1)
	var exit_threshold := float(target + 1) if direction > 0 else float(target)
	var enter := _find_crossing(times, values, enter_threshold, direction)
	var exit := _find_crossing(times, values, exit_threshold, direction)
	if exit < 0.0:
		var last_value: float = values[values.size() - 1]
		if (direction > 0 and target >= int(last_value)) or (direction < 0 and target <= int(last_value)):
			exit = anim.length
	return Vector2(enter, exit)


func _find_crossing(times: PackedFloat32Array, values: Array, threshold: float, direction: int) -> float:
	for i in range(times.size() - 1):
		var t0 := times[i]
		var t1 := times[i + 1]
		var v0: float = values[i]
		var v1: float = values[i + 1]
		if is_equal_approx(v0, v1):
			continue
		if (direction > 0 and v1 < v0) or (direction < 0 and v1 > v0):
			continue
		var lo := minf(v0, v1)
		var hi := maxf(v0, v1)
		if threshold < lo or threshold > hi:
			continue
		var ratio := (threshold - v0) / (v1 - v0)
		return t0 + ratio * (t1 - t0)
	return -1.0
