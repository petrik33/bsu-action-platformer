class_name Kinematic extends PhysicsNodeBase

@export var max_speed: float = 150.0
@export var stop_buffer: float = 0.5
@export var horizontal_only: bool = true

var _steering_accumulator := Vector2.ZERO
var _weight_accumulator := 0.0

func dash(velocity: Vector2):
	if horizontal_only:
		body.velocity.x = velocity.x
	else:
		body.velocity = velocity

func add_steering(steering: Vector2, weight: float = 1.0):
	if steering.is_zero_approx():
		return
	if horizontal_only:
		_steering_accumulator.x += steering.x * weight
	else:
		_steering_accumulator += steering * weight
	_weight_accumulator += weight

func apply_steering(delta: float, max_acceleration: float):
	if _weight_accumulator <= 0:
		return

	var blended_steering := _steering_accumulator / _weight_accumulator
	blended_steering = blended_steering.limit_length(max_acceleration)

	body.velocity.x += (blended_steering * delta).x
	var resulting_speed := absf(body.velocity.x)

	if resulting_speed <= stop_buffer:
		body.velocity.x = 0
	else:
		body.velocity.x = signf(body.velocity.x) * min(resulting_speed, max_speed)

	_steering_accumulator = Vector2.ZERO
	_weight_accumulator = 0.0
