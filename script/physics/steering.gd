class_name Steering extends Node

@export var max_speed: float = 400
@export var max_acceleration: float = 2000
@export var deceleration: float = 2000
@export var horizontal_only: bool = true

var body: CharacterBody2D
var force: Vector2 = Vector2.ZERO


func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Steering component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Steering component must be a child of CharacterBody2D"]
	return []


func update(applied_force: Vector2):
	force = applied_force

func apply(delta: float):
	if horizontal_only:
		force.y = 0
	body.velocity += force * delta
	body.velocity = body.velocity.limit_length(max_speed)
	force = Vector2.ZERO

?func seek(target_position: Vector2, acceleration := -1.0) -> Vector2:
	if acceleration < 0:
		acceleration = max_acceleration
	return (target_position - body.global_position).normalized() * acceleration

func arrive(
	target_position: Vector2,
	target_radius: float = 4.0,
	slowing_radius: float = 40.0,
	time_to_target: float = 0.1,
	acceleration: float = -1.0
) -> Vector2:
	var to_target = target_position - body.global_position
	var distance = to_target.length()

	if distance < target_radius:
		return Vector2.ZERO

	var target_speed := max_speed
	if distance <= slowing_radius:
		target_speed *= distance / slowing_radius
	
	var target_velocity := to_target.normalized() * target_speed
	var output := target_velocity - body.velocity
	output /= time_to_target
	
	if acceleration < 0:
		acceleration = max_acceleration
	
	output = output.limit_length(acceleration)
	
	return output

func velocity_match(target: Vector2,
	time_to_target: float = 0.1,
	acceleration: float = -1.0
) -> Vector2:
	var output := target - body.velocity
	output /= time_to_target
	
	if acceleration < 0:
		acceleration = max_acceleration
		
	output = output.limit_length(acceleration)
	return output

func stop() -> Vector2:
	return velocity_match(Vector2.ZERO, 0.1, deceleration)

func dash(velocity: Vector2) -> Vector2:
	return velocity - body.velocity
