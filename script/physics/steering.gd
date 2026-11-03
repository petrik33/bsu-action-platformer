class_name Steering extends Node

@export var max_speed: float = 400
@export var acceleration: float = 2000
@export var deceleration: float = 2000
@export var horizontal_only: bool = true

var body: CharacterBody2D
var target_velocity: Vector2 = Vector2.ZERO
var current_acceleration: float = -1.0


func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Steering component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Steering component must be a child of CharacterBody2D"]
	return []


func apply(delta: float):
	if current_acceleration < 0:
		return
	var final_target = target_velocity.limit_length(max_speed)
	if not horizontal_only:
		body.velocity = body.velocity.move_toward(final_target, delta * current_acceleration)
	else:
		body.velocity.x = move_toward(body.velocity.x, final_target, delta * current_acceleration)

func clear_target():
	target_velocity = Vector2.ZERO
	current_acceleration = -1.0

func seek(target_position: Vector2):
	var desired_velocity = (target_position - body.global_position).normalized() * max_speed
	target_velocity += desired_velocity

func arrive(target_position: Vector2, slowing_radius: float):
	var to_target = target_position - body.global_position
	var distance = to_target.length()

	var speed = max_speed
	if distance < slowing_radius:
		speed = max_speed * (distance / slowing_radius)

	var desired_velocity = to_target.normalized() * speed
	target_velocity += desired_velocity

func stop():
	target_velocity = Vector2.ZERO
	current_acceleration = deceleration

func match_velocity(value: Vector2):
	target_velocity = value
	current_acceleration = acceleration

func dash(velocity: Vector2):
	body.velocity = velocity
	current_acceleration = -1.0
