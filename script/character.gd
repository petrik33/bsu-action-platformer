class_name Character extends CharacterBody2D


signal animation_finished(anim_name: StringName)


@export var default_speed := 300.0
@export var gravity := 900.0
@export var acceleration := 2000.0
@export var decceleration := 1250.0


@export var state_machine: CharacterStateMachine
@export var sprite: AnimatedSprite2D
@export var visuals: Node2D
@export var hit_box: Area2D
@export var animation_player: AnimationPlayer


var speed: float


func _ready() -> void:
	reset_speed()
	state_machine.initialize(self)


func _process(_delta: float) -> void:
	state_machine.handle_input()


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += delta * gravity
	
	var input_direction := signf(Input.get_axis("left", "right"))
	var movement_direction := signf(velocity.x)
	
	var is_moving := not is_zero_approx(velocity.x)
	var is_accelerating := not is_zero_approx(input_direction) \
		and input_direction == movement_direction \
		and absf(velocity.x) <= speed
	
	var target_speed := speed * input_direction
	var rate := acceleration if is_accelerating else decceleration
	
	velocity.x = move_toward(velocity.x, target_speed, rate * delta)
	
	if is_moving:
		flip(movement_direction)
	
	move_and_slide()
	
	state_machine.update()


func set_animation(anim_name: StringName):
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		sprite.play(anim_name)


func play_animation(anim_name: StringName):
	if animation_player.has_animation(anim_name):
		animation_player.animation_finished.connect(
			_on_animation_player_animation_finished,
			CONNECT_ONE_SHOT
		)
		animation_player.play(anim_name)
	elif sprite.sprite_frames.has_animation(anim_name):
		sprite.animation_finished.connect(
			_on_sprite_animation_finished,
			CONNECT_ONE_SHOT
		)
		sprite.play(anim_name)


func reset_speed():
	speed = default_speed


func flip(direction: float):
	visuals.scale.x = sign(direction)
	hit_box.scale.x = sign(direction)


func accelerate(delta: float, target: float):
	velocity.x = move_toward(
		velocity.x, target, acceleration * delta
	)


func deccelerate(delta: float, target: float):
	velocity.x = move_toward(
		velocity.x, target, decceleration * delta
	)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)


func _on_sprite_animation_finished() -> void:
	animation_finished.emit(sprite.animation)
