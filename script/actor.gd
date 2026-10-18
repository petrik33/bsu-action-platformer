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

func play_animation(anim_name: StringName):
	if animation_player and animation_player.has_animation(anim_name):
		sprite.stop()
		animation_player.play(anim_name)
		return
	if sprite.sprite_frames.has_animation(anim_name):
		reset_animation_player()
		sprite.play(anim_name)

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


func _on_animation_player_animation_finished(_anim_name: StringName):
	animation_finished.emit()


func _on_sprite_animation_finished():
	animation_finished.emit()
