class_name Steering extends Node

@export var max_speed: float = 400
@export var acceleration: float = 2000
@export var deceleration: float = 2000
@export var horizontal_only: bool = true

var body: CharacterBody2D
var desired_velocity: Vector2 = Vector2.ZERO

func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Steering component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Steering component must be a child of CharacterBody2D"]
	return []

func set_desired_velocity(velocity: Vector2):
	desired_velocity = velocity.limit_length(max_speed)

func set_horizontal_velocity(value: float):
	desired_velocity.x = clamp(value, -max_speed, max_speed)

func set_instant_velocity(velocity: Vector2):
	if body:
		body.velocity = velocity
		desired_velocity = velocity

func apply(delta: float):
	if not body:
		return

	var target_velocity = desired_velocity
	if horizontal_only:
		target_velocity.y = body.velocity.y
	
	var accel_to_use = acceleration if desired_velocity.length() > 0 else deceleration
	body.velocity = body.velocity.move_toward(target_velocity, accel_to_use * delta)
