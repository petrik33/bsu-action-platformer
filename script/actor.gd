class_name Actor extends CharacterBody2D


signal animation_finished()


@export var visuals: Node2D
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	if not animation_player:
		return
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func face_movement():
	face(velocity.x)

func face(direction: float):
	if is_zero_approx(direction):
		return
	visuals.scale.x = signf(direction)

func facing_direction() -> float:
	return sign(visuals.scale.x)

func turn_around():
	face(-facing_direction())

func play_animation(anim_name: StringName, time: float = -1.0):
	sprite.stop()
	if animation_player and animation_player.has_animation(anim_name):
		animation_player.play(anim_name, -1, _calc_animation_player_animation_speed(anim_name, time))
		return
	if sprite.sprite_frames.has_animation(anim_name):
		reset_animation_player()
		sprite.play(anim_name, _calc_sprite_animation_speed(anim_name, time))

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


func _calc_sprite_animation_speed(anim_name: StringName, time: float) -> float:
	if time <= 0.0 or not sprite.sprite_frames.has_animation(anim_name):
		return 1.0
	
	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var fps := sprite.sprite_frames.get_animation_speed(anim_name)
	
	if frame_count <= 0 or is_zero_approx(fps):
		return 1.0
		
	var default_duration := frame_count / fps
	return default_duration / time

func _calc_animation_player_animation_speed(anim_name: StringName, time: float) -> float:
	if time <= 0.0 or not animation_player or not animation_player.has_animation(anim_name):
		return 1.0
		
	var anim := animation_player.get_animation(anim_name)
	if not anim or is_zero_approx(anim.length):
		return 1.0
		
	return anim.length / time
	

func _on_animation_player_animation_finished(_anim_name: StringName):
	animation_finished.emit()

func _on_sprite_animation_finished():
	animation_finished.emit()
