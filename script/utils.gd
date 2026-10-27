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
