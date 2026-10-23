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

@export var marker: Marker2D:
	set(value):
		marker = value
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

## Animation used as the grounded reference for feature pattern matching.
@export var idle_anim_name: String = "idle":
	set(value):
		idle_anim_name = value
		update_configuration_warnings()

@export_group("Alignment Mode")
## If true, locks final output Y to initial level and only auto-tracks X offset.
@export var lock_y_to_feet: bool = true

@export_group("Feature Tracking")
## Enables pixel pattern matching relative to current marker setup on Idle frame 0.
@export var enable_pixel_tracking: bool = true
## Maximum pixel search range frame-to-frame. Increase if character moves fast between frames.
@export_range(4, 64) var search_radius: int = 16
## Size of the pixel patch to sample (odd numbers work best, e.g., 5x5, 7x7).
@export_range(3, 15) var patch_size: int = 7

@export_tool_button("Generate Origin Track", "Animation")
var _generate_button = generate_marker_track


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
			if enable_pixel_tracking and not idle_anim_name.is_empty() and not sprite.sprite_frames.has_animation(idle_anim_name):
				warnings.append("SpriteFrames resource does not contain idle animation: '%s'" % idle_anim_name)

	if not marker:
		warnings.append("Marker2D is not assigned.")

	if sprite_anim_name.strip_edges().is_empty():
		warnings.append("Sprite Animation Name cannot be empty.")
	if anim_player_anim_name.strip_edges().is_empty():
		warnings.append("AnimationPlayer Animation Name cannot be empty.")
	if enable_pixel_tracking and idle_anim_name.strip_edges().is_empty():
		warnings.append("Idle Animation Name cannot be empty when feature tracking is enabled.")

	return warnings


func generate_marker_track() -> void:
	var warnings = _get_configuration_warnings()
	if not warnings.is_empty():
		printerr("Cannot generate tracks. Fix configuration warnings first:")
		for w in warnings:
			printerr(" - ", w)
		return

	var anim: Animation = anim_player.get_animation(anim_player_anim_name)
	var frames_res: SpriteFrames = sprite.sprite_frames
	var frame_count = frames_res.get_frame_count(sprite_anim_name)
	
	var root_node = anim_player.get_node_or_null(anim_player.root_node)
	if not root_node:
		root_node = anim_player.get_parent()
		
	var relative_marker_path = root_node.get_path_to(marker)
	var track_path = NodePath(String(relative_marker_path) + ":position")
	
	var track_idx = anim.find_track(track_path, Animation.TYPE_VALUE)
	if track_idx == -1:
		track_idx = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(track_idx, track_path)
	
	while anim.track_get_key_count(track_idx) > 0:
		anim.track_remove_key(track_idx, 0)

	var frame_duration = anim.length / max(1, frame_count)
	
	var ref_patch: Array[Color] = []
	var half_patch = patch_size / 2
	
	# Track position in local node space, NOT absolute texture pixels
	var initial_marker_local_pos = marker.position - sprite.position
	var current_marker_local_pos = initial_marker_local_pos
	var last_offset = Vector2.ZERO

	# 1. Establish initial pattern from Idle Frame 0 based on user's current marker placement
	if enable_pixel_tracking and frames_res.has_animation(idle_anim_name):
		var idle_texture = frames_res.get_frame_texture(idle_anim_name, 0)
		if idle_texture:
			var idle_img = idle_texture.get_image()
			var img_size = Vector2(idle_img.get_size())
			
			var sprite_origin_in_texture := Vector2.ZERO
			if sprite.centered:
				sprite_origin_in_texture = (img_size / 2.0) + sprite.offset
			else:
				sprite_origin_in_texture = sprite.offset
				
			var start_pixel = sprite_origin_in_texture + current_marker_local_pos
			ref_patch = _sample_patch_above_anchor(idle_img, Vector2i(round(start_pixel.x), round(start_pixel.y)), half_patch, patch_size, lock_y_to_feet)

	for i in range(frame_count):
		var texture = frames_res.get_frame_texture(sprite_anim_name, i)
		if texture:
			var img = texture.get_image()
			var img_size = Vector2(img.get_size())
			
			var sprite_origin_in_texture := Vector2.ZERO
			if sprite.centered:
				sprite_origin_in_texture = (img_size / 2.0) + sprite.offset
			else:
				sprite_origin_in_texture = sprite.offset

			# Map the logical tracked node position to the current frame's specific canvas size
			var expected_pixel = sprite_origin_in_texture + current_marker_local_pos
			var target_pixel_pos = expected_pixel

			if enable_pixel_tracking and not ref_patch.is_empty():
				var active_radius = max(search_radius, 64) if i == 0 else search_radius
				
				target_pixel_pos = _find_best_patch_match(img, Vector2i(round(expected_pixel.x), round(expected_pixel.y)), ref_patch, half_patch, patch_size, active_radius, lock_y_to_feet)
				
				if img.get_pixelv(Vector2i(target_pixel_pos)).a > 0.2:
					ref_patch = _sample_patch_above_anchor(img, Vector2i(target_pixel_pos), half_patch, patch_size, lock_y_to_feet)
			
			# Convert the found pixel back into local node space coordinates
			current_marker_local_pos = target_pixel_pos - sprite_origin_in_texture

			if lock_y_to_feet:
				# Keep Y strictly locked to the initial user placement
				last_offset = sprite.position + Vector2(current_marker_local_pos.x, initial_marker_local_pos.y) 
			else:
				last_offset = sprite.position + current_marker_local_pos
			
			var time = i * frame_duration
			anim.track_insert_key(track_idx, time, last_offset)

	var end_time = anim.length
	if anim.track_find_key(track_idx, end_time, Animation.FIND_MODE_EXACT) == -1:
		anim.track_insert_key(track_idx, end_time, last_offset)

	print("Successfully keyframed tracked marker positions for: ", anim_player_anim_name)


func _sample_patch_above_anchor(img: Image, anchor: Vector2i, half_patch: int, p_size: int, y_locked: bool) -> Array[Color]:
	var patch: Array[Color] = []
	var img_size = img.get_size()

	var y_start = -p_size if y_locked else -half_patch
	var y_end = 0 if y_locked else half_patch

	for dy in range(y_start, y_end + 1):
		for dx in range(-half_patch, half_patch + 1):
			var px = clampi(anchor.x + dx, 0, img_size.x - 1)
			var py = clampi(anchor.y + dy, 0, img_size.y - 1)
			patch.append(img.get_pixel(px, py))

	return patch


func _find_best_patch_match(img: Image, last_known_pos: Vector2i, ref_patch: Array[Color], half_patch: int, p_size: int, radius: int, y_locked: bool) -> Vector2:
	var best_pos = Vector2(last_known_pos)
	var min_error = INF
	var img_size = img.get_size()

	var y_start = -p_size if y_locked else -half_patch
	var y_end = 0 if y_locked else half_patch

	for ry in range(-radius, radius + 1):
		for rx in range(-radius, radius + 1):
			var candidate_anchor = last_known_pos + Vector2i(rx, ry)
			var current_error = 0.0
			var patch_idx = 0

			for dy in range(y_start, y_end + 1):
				for dx in range(-half_patch, half_patch + 1):
					var ref_color = ref_patch[patch_idx]
					patch_idx += 1

					var px = clampi(candidate_anchor.x + dx, 0, img_size.x - 1)
					var py = clampi(candidate_anchor.y + dy, 0, img_size.y - 1)
					var candidate_color = img.get_pixel(px, py)

					var r_diff = candidate_color.r - ref_color.r
					var g_diff = candidate_color.g - ref_color.g
					var b_diff = candidate_color.b - ref_color.b
					var a_diff = (candidate_color.a - ref_color.a) * 3.0
					
					current_error += (r_diff * r_diff + g_diff * g_diff + b_diff * b_diff + a_diff * a_diff)

			if current_error < min_error:
				min_error = current_error
				best_pos = Vector2(candidate_anchor)

	return best_pos
