@tool
extends Node

@export_group("Target Nodes")
@export var anim_player: AnimationPlayer:
	set(value):
		anim_player = value
		update_configuration_warnings()

@export var sprite: AnimatedSprite2D:
	set(value):
		sprite = value
		update_configuration_warnings()

@export var tracker: Node2D:
	set(value):
		tracker = value
		update_configuration_warnings()

@export_group("Animation Settings")
@export var sprite_anim_name: String = "attack":
	set(value):
		sprite_anim_name = value
		if anim_player_anim_name.is_empty():
			anim_player_anim_name = value
		update_configuration_warnings()

@export var anim_player_anim_name: String = "attack":
	set(value):
		anim_player_anim_name = value
		update_configuration_warnings()

@export_group("Alignment Mode")
## If true, locks Y to the tracker's current Y coordinate and limits searches to a horizontal line.
@export var lock_y: bool = false

@export_group("Feature Tracking")
## Enables pixel pattern matching relative to current setup's sampled pixel anchor.
@export var enable_pixel_tracking: bool = true
## If true, updates the reference color patch every frame. Useful when the tracked feature changes shape or lighting over time. If false, strictly searches for the initial frame's patch colors (though the search anchor still moves to the previous found position).
@export var update_patch_per_frame: bool = true
## Radius (in pixels) around the baseline position to search for the pixel pattern match.
@export_range(2, 64) var search_radius: int = 8
## Size of the pixel patch to sample (1 samples a single pixel; odd sizes work best).
@export_range(1, 15) var patch_size: int = 5

@export_tool_button("Generate Track", "Animation")
var generate_button = generate_tracker_track


func generate_tracker_track() -> void:
	var warnings = _get_configuration_warnings()
	if not warnings.is_empty():
		printerr("Cannot generate tracks. Fix configuration warnings first:")
		for w in warnings:
			printerr(" - ", w)
		return
	
	var initial_tracker_pos := tracker.position
	var anim: Animation = anim_player.get_animation(anim_player_anim_name)
	var frames_res: SpriteFrames = sprite.sprite_frames

	var root_node = anim_player.get_node_or_null(anim_player.root_node)
	if not root_node:
		root_node = anim_player.get_parent()

	var relative_tracker_path := root_node.get_path_to(tracker)
	var track_path := NodePath(String(relative_tracker_path) + ":position")

	var track_idx = anim.find_track(track_path, Animation.TYPE_VALUE)
	if track_idx == -1:
		track_idx = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(track_idx, track_path)
	
	anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)

	while anim.track_get_key_count(track_idx) > 0:
		anim.track_remove_key(track_idx, 0)

	var ref_anim := sprite.animation
	var ref_frame := sprite.frame
	var ref_texture := frames_res.get_frame_texture(ref_anim, ref_frame)
	if not ref_texture:
		printerr("Cannot read texture from current sprite frame.")
		return

	var ref_img := ref_texture.get_image()
	var ref_used_rect := ref_img.get_used_rect()
	if ref_used_rect.size == Vector2i.ZERO:
		ref_used_rect = Rect2i(Vector2i.ZERO, ref_img.get_size())

	var ref_tracker_pos := sprite.to_local(tracker.global_position)
	var ref_pixel_pos := _sprite_local_to_image_pixel(ref_img, ref_tracker_pos)

	var relative_norm_pos := Vector2(
		(ref_pixel_pos.x - ref_used_rect.position.x) / float(ref_used_rect.size.x),
		(ref_pixel_pos.y - ref_used_rect.position.y) / float(ref_used_rect.size.y)
	)

	var ref_patch: Array[Color] = []
	var half_patch: int = floori(patch_size / 2.0)
	if enable_pixel_tracking:
		var ref_anchor_point = Vector2i(round(ref_pixel_pos.x), round(ref_pixel_pos.y))
		ref_patch = _sample_patch(ref_img, ref_anchor_point, half_patch)

	var current_pixel_pos := ref_pixel_pos
	
	var original_anim = anim_player.assigned_animation
	var original_pos = anim_player.current_animation_position
	
	anim_player.assigned_animation = anim_player_anim_name
	
	var step_resolution = anim.step
	if step_resolution <= 0.0:
		step_resolution = 1.0 / 60.0
		
	var last_processed_frame := -1
	var t := 0.0

	while t <= anim.length + (step_resolution / 2.0):
		anim_player.seek(t, true)
		var current_frame = sprite.frame
		
		if current_frame != last_processed_frame:
			var texture = frames_res.get_frame_texture(sprite_anim_name, current_frame)
			if texture:
				var img = texture.get_image()
				var used_rect = img.get_used_rect()
				if used_rect.size == Vector2i.ZERO:
					used_rect = Rect2i(Vector2i.ZERO, img.get_size())

				var baseline_point: Vector2i
				if enable_pixel_tracking:
					baseline_point = Vector2i(round(current_pixel_pos.x), round(current_pixel_pos.y))
				else:
					baseline_point = Vector2i(
						round(used_rect.position.x + (relative_norm_pos.x * used_rect.size.x)),
						round(used_rect.position.y + (relative_norm_pos.y * used_rect.size.y))
					)

				var target_pixel_pos = Vector2(baseline_point)

				if enable_pixel_tracking and not ref_patch.is_empty():
					target_pixel_pos = _find_best_patch_match(img, baseline_point, ref_patch, half_patch, search_radius, lock_y)
					current_pixel_pos = target_pixel_pos
					if update_patch_per_frame:
						ref_patch = _sample_patch(img, Vector2i(target_pixel_pos), half_patch)
				
				var target_sprite_pos := _image_pixel_to_sprite_local(img, target_pixel_pos)
				var target_tracker_pos := _convert_sprite_local_to_tracker_parent(target_sprite_pos)

				if lock_y:
					target_tracker_pos.y = initial_tracker_pos.y

				anim.track_insert_key(track_idx, t, target_tracker_pos)
				
			last_processed_frame = current_frame
			
		t += step_resolution

	if not original_anim.is_empty():
		anim_player.assigned_animation = original_anim
		anim_player.seek(original_pos, true)

	print("Successfully keyframed tracked positions for: ", anim_player_anim_name)


func _convert_sprite_local_to_tracker_parent(sprite_local_pos: Vector2) -> Vector2:
	var global_pos = sprite.to_global(sprite_local_pos)
	
	var tracker_parent = tracker.get_parent()
	if tracker_parent and tracker_parent is Node2D:
		return tracker_parent.to_local(global_pos)
		
	return global_pos

func _sprite_local_to_image_pixel(tex: Image, point_in_sprite: Vector2) -> Vector2:
	return point_in_sprite + (tex.get_size() / 2.0) * int(sprite.centered) - sprite.offset

func _image_pixel_to_sprite_local(tex: Image, point_in_texture: Vector2) -> Vector2:
	return point_in_texture - _sprite_local_to_image_pixel(tex, Vector2.ZERO)

func _sample_patch(img: Image, center: Vector2i, half_patch: int) -> Array[Color]:
	var patch: Array[Color] = []
	var img_size = img.get_size()

	for dy in range(-half_patch, half_patch + 1):
		for dx in range(-half_patch, half_patch + 1):
			var px = clampi(center.x + dx, 0, img_size.x - 1)
			var py = clampi(center.y + dy, 0, img_size.y - 1)
			patch.append(img.get_pixel(px, py))

	return patch


func _find_best_patch_match(img: Image, baseline: Vector2i, ref_patch: Array[Color], half_patch: int, radius: int, lock_y_axis: bool) -> Vector2:
	var best_pos = Vector2(baseline)
	var min_error = INF
	var img_size = img.get_size()

	var y_min = 0 if lock_y_axis else -radius
	var y_max = 0 if lock_y_axis else radius

	for ry in range(y_min, y_max + 1):
		for rx in range(-radius, radius + 1):
			var candidate_center = baseline + Vector2i(rx, ry)
			var current_error = 0.0
			var patch_idx = 0

			for dy in range(-half_patch, half_patch + 1):
				for dx in range(-half_patch, half_patch + 1):
					var px = clampi(candidate_center.x + dx, 0, img_size.x - 1)
					var py = clampi(candidate_center.y + dy, 0, img_size.y - 1)
					var candidate_color = img.get_pixel(px, py)
					var ref_color = ref_patch[patch_idx]
					patch_idx += 1

					var r_diff = candidate_color.r - ref_color.r
					var g_diff = candidate_color.g - ref_color.g
					var b_diff = candidate_color.b - ref_color.b
					var a_diff = candidate_color.a - ref_color.a

					current_error += (r_diff * r_diff + g_diff * g_diff + b_diff * b_diff + a_diff * a_diff)

			if current_error < min_error:
				min_error = current_error
				best_pos = Vector2(candidate_center)

	return best_pos

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if not anim_player:
		warnings.append("AnimationPlayer is not assigned.")
	elif not anim_player_anim_name.is_empty() and not anim_player.has_animation(anim_player_anim_name):
		warnings.append("AnimationPlayer does not contain animation: '%s'" % anim_player_anim_name)

	if not sprite:
		warnings.append("AnimatedSprite2D is not assigned.")
	else:
		if not sprite.sprite_frames:
			warnings.append("AnimatedSprite2D has no SpriteFrames resource assigned.")
		else:
			if not sprite_anim_name.is_empty() and not sprite.sprite_frames.has_animation(sprite_anim_name):
				warnings.append("SpriteFrames resource does not contain target animation: '%s'" % sprite_anim_name)
			if sprite.animation.is_empty() or not sprite.sprite_frames.has_animation(sprite.animation):
				warnings.append("AnimatedSprite2D must have a valid current animation selected in the editor.")

	if not tracker:
		warnings.append("Tracker Node2D is not assigned.")

	if sprite_anim_name.strip_edges().is_empty():
		warnings.append("Sprite Animation Name cannot be empty.")

	if anim_player_anim_name.strip_edges().is_empty():
		warnings.append("AnimationPlayer Animation Name cannot be empty.")

	if anim_player and sprite and anim_player.has_animation(anim_player_anim_name):
		var anim: Animation = anim_player.get_animation(anim_player_anim_name)
		var root_node = anim_player.get_node_or_null(anim_player.root_node)
		if not root_node:
			root_node = anim_player.get_parent()

		var relative_sprite_path = root_node.get_path_to(sprite)
		var sprite_frame_track_path = NodePath(String(relative_sprite_path) + ":frame")
		var sprite_frame_track_idx = anim.find_track(sprite_frame_track_path, Animation.TYPE_VALUE)

		if sprite_frame_track_idx == -1:
			warnings.append("Animation '%s' is missing a '%s' track." % [anim_player_anim_name, sprite_frame_track_path])
		elif anim.track_get_key_count(sprite_frame_track_idx) == 0:
			warnings.append("The '%s' track must contain at least 1 keyframe." % sprite_frame_track_path)

	return warnings
