class_name Character extends CharacterBody2D


signal animation_finished(anim_name: StringName)


@export var gravity := 900.0


@export var state_machine: CharacterStateMachine
@export var sprite: AnimatedSprite2D
@export var visuals: Node2D
@export var hit_box: Area2D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	state_machine.initialize(self)


func _process(delta: float) -> void:
	state_machine.handle_input(delta)


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += delta * gravity
	state_machine.update_physics(delta)
	move_and_slide()


func play_animation(anim_name: StringName):
	if animation_player.has_animation(anim_name):
		animation_player.animation_finished.connect(
			_emit_animation_finished, CONNECT_ONE_SHOT
		)
		animation_player.play(anim_name)
		return
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.animation_finished.connect(
			_emit_animation_finished, CONNECT_ONE_SHOT
		)
		sprite.play(anim_name)


func update_horizontal_velocity(speed: float, direction: float):
	velocity.x = speed * sign(direction)


func flip(direction: float):
	visuals.scale.x = sign(direction)
	hit_box.scale.x = sign(direction)


func _emit_animation_finished(anim_name: StringName):
	animation_finished.emit(anim_name)
