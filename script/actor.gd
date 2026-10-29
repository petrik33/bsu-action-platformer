class_name Actor extends CharacterBody2D

@export var visuals: Node2D
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var origin: Node2D

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

func turn_around():
	face(-facing_direction())

func play_animation(anim_name: StringName, time: float = -1.0):
	sprite.stop()
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

func stop_animation():
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
