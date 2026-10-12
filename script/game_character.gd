class_name GameCharacter extends CharacterBody2D


signal animation_finished()


@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

@export var state_machine: CharacterStateMachine

@export var gravity_enabled: bool = true
@export var speed: float = 400
@export var gravity: float = 900
@export var default_speed: float = 400
@export var jump_speed: float = 350


var jumps_left := 2
var movement_direction := 0.0


func _process(_delta: float) -> void:
	state_machine.handle_input()


func _physics_process(delta: float) -> void:
	movement_direction = signf(Input.get_axis("left", "right"))
	
	state_machine.process_physics(delta)
	
	if not is_on_floor():
		velocity.y += float(gravity_enabled) * get_gravity().y * delta
	else:
		jumps_left = 2
	
	velocity.x = movement_direction * speed
	
	move_and_slide()
	
	state_machine.post_physics()


func facing_direction() -> float:
	return sign(scale.x)

func can_jump() -> bool:
	return jumps_left > 0

func jump():
	jumps_left -= 1
	velocity.y = -jump_speed

func reset_speed():
	speed = default_speed

func play_animation(anim_name: StringName):
	if animation_player.has_animation(anim_name):
		sprite.stop()
		animation_player.play(anim_name)
		return
	if sprite.sprite_frames.has_animation(anim_name):
		animation_player.stop()
		sprite.play(anim_name)

func stop_animation():
	if animation_player.is_playing():
		animation_player.stop()
		return
	if sprite.is_playing():
		sprite.stop()


func _on_animation_player_animation_finished(_anim_name: StringName):
	animation_finished.emit()


func _on_sprite_animation_finished():
	animation_finished.emit()


func _emit_animation_finished():
	animation_finished.emit()
