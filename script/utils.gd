class_name Utils extends Node


static func get_anim_player_target_speed(
	anim_player: AnimationPlayer, anim_name: StringName, time: float
) -> float:
	if time <= 0.0 or not anim_player or not anim_player.has_animation(anim_name):
		return 1.0
		
	var anim := anim_player.get_animation(anim_name)
	if not anim or is_zero_approx(anim.length):
		return 1.0
		
	return anim.length / time


static func get_sprite_animation_target_speed(
	sprite: AnimatedSprite2D, anim_name: StringName, time: float
) -> float:
	if time <= 0:
		return 1.0
	return get_sprite_animation_length(sprite, anim_name) / time


static func get_sprite_animation_length(
	sprite: AnimatedSprite2D, anim_name: StringName
) -> float:
	if not sprite.sprite_frames.has_animation(anim_name):
		return 0.0
	
	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var fps := sprite.sprite_frames.get_animation_speed(anim_name)
	
	if frame_count <= 0 or is_zero_approx(fps):
		return 1.0
		
	return frame_count / fps


static func get_sprite_frame_window(
	sprite: AnimatedSprite2D, anim_name: StringName, frame: int, time: float
) -> Vector2:
	if sprite == null or sprite.sprite_frames == null:
		return Vector2(-1.0, -1.0)
	if not sprite.sprite_frames.has_animation(anim_name):
		return Vector2(-1.0, -1.0)

	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var resolved := _resolve_frame(frame, frame_count)
	if resolved < 0:
		return Vector2(-1.0, -1.0)

	var total := time if time > 0.0 else get_sprite_animation_length(sprite, anim_name)
	var enter := float(resolved) / frame_count * total
	var exit := float(resolved + 1) / frame_count * total
	return Vector2(enter, exit)


static func get_anim_player_frame_window(
	animation_player: AnimationPlayer, sprite: AnimatedSprite2D,
	anim_name: StringName, frame: int, time: float
) -> Vector2:
	if animation_player == null or sprite == null:
		return Vector2(-1.0, -1.0)

	var anim := animation_player.get_animation(anim_name)
	if anim == null:
		return Vector2(-1.0, -1.0)

	var track := _find_sprite_track(animation_player, sprite, anim, &"frame")
	if track < 0:
		return Vector2(-1.0, -1.0)

	var key_count := anim.track_get_key_count(track)
	if key_count < 2:
		return Vector2(-1.0, -1.0)

	var frame_count := _get_anim_frame_count(animation_player, anim, sprite, track)
	var resolved := _resolve_frame(frame, frame_count)
	if resolved < 0:
		return Vector2(-1.0, -1.0)

	var start_time := anim.track_get_key_time(track, 0)
	var end_time := anim.track_get_key_time(track, key_count - 1)
	var start_frame := float(anim.track_get_key_value(track, 0))
	var end_frame := float(anim.track_get_key_value(track, key_count - 1))
	if is_equal_approx(start_frame, end_frame):
		return Vector2(-1.0, -1.0)

	var direction := 1.0 if end_frame > start_frame else -1.0
	var enter := _linear_frame_time(start_time, end_time, start_frame, end_frame, float(resolved))
	var exit := _linear_frame_time(start_time, end_time, start_frame, end_frame, float(resolved) + direction)
	if enter < 0.0:
		return Vector2(-1.0, -1.0)
	if exit < 0.0:
		exit = end_time

	var speed := get_anim_player_target_speed(animation_player, anim_name, time)
	return Vector2(enter / speed, exit / speed)


static func _linear_frame_time(
	start_time: float, end_time: float, start_frame: float, end_frame: float, target: float
) -> float:
	var span := end_frame - start_frame
	if is_zero_approx(span):
		return -1.0
	var ratio := (target - start_frame) / span
	if ratio < 0.0 or ratio > 1.0:
		return -1.0
	return start_time + ratio * (end_time - start_time)


static func _resolve_frame(frame: int, frame_count: int) -> int:
	if frame_count <= 0:
		return -1
	var resolved := frame if frame >= 0 else frame_count + frame
	if resolved < 0 or resolved >= frame_count:
		return -1
	return resolved


static func _find_sprite_track(
	animation_player: AnimationPlayer, sprite: AnimatedSprite2D,
	anim: Animation, subname: StringName
) -> int:
	var root := _get_animation_root(animation_player)
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


static func _get_animation_root(animation_player: AnimationPlayer) -> Node:
	if animation_player == null:
		return null
	if animation_player.root_node.is_empty():
		return animation_player.get_parent()
	return animation_player.get_node_or_null(animation_player.root_node)


static func _get_anim_frame_count(
	animation_player: AnimationPlayer, anim: Animation, sprite: AnimatedSprite2D, frame_track: int
) -> int:
	var anim_track := _find_sprite_track(animation_player, sprite, anim, &"animation")
	if anim_track >= 0 and anim.track_get_key_count(anim_track) > 0:
		var sprite_anim: StringName = anim.track_get_key_value(anim_track, 0)
		if sprite.sprite_frames and sprite.sprite_frames.has_animation(sprite_anim):
			return sprite.sprite_frames.get_frame_count(sprite_anim)
	var key_count := anim.track_get_key_count(frame_track)
	if key_count > 0:
		return int(float(anim.track_get_key_value(frame_track, key_count - 1))) + 1
	return 0
