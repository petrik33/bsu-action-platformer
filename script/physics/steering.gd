class_name Steering extends Node

@export var max_speed: float = 400
@export var acceleration: float = 2000
@export var deceleration: float = 2000

var body: CharacterBody2D


func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Steering component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Steering component must be a child of CharacterBody2D"]
	return []

func dash_vec(velocity: Vector2):
	body.velocity = velocity

func dash(velocity: float):
	body.velocity.x = velocity

func apply_vec(delta: float, velocity: Vector2):
	var accel_to_use = acceleration if velocity.length() > 0 else deceleration
	apply_forced_vec(delta, velocity, accel_to_use)

func apply(delta: float, velocity: float):
	var accel_to_use = acceleration if velocity != 0 else deceleration
	apply_forced(delta, velocity, accel_to_use)

func apply_forced_vec(delta: float, velocity: Vector2, value: float):
	var target_velocity = velocity.limit_length(max_speed)
	body.velocity = body.velocity.move_toward(target_velocity, delta * value)

func apply_forced(delta: float, velocity: float, value: float):
	var target_velocity = clamp(velocity, -max_speed, max_speed)
	body.velocity.x = move_toward(body.velocity.x, target_velocity, delta * value)
