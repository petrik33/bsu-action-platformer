class_name Kinematic extends PhysicsNodeBase

@export var max_speed: float = 150.0
@export var stop_buffer: float = 0.5
@export var horizontal_only: bool = true

var _steering_accumulator := Vector2.ZERO
var _weight_accumulator := 0.0

func current_speed() -> float:
	if horizontal_only:
		return absf(body.velocity.x)
	else:
		return body.velocity.length()

func full_stop():
	if horizontal_only:
		body.velocity.x = 0
	else:
		body.velocity = Vector2.ZERO

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
	var resulting_steering := blended_steering * delta
	
	if horizontal_only:
		body.velocity.x += resulting_steering.x
	else:
		body.velocity += resulting_steering
	
	if current_speed() <= stop_buffer:
		full_stop()
	else:
		_limit_speed()

	_steering_accumulator = Vector2.ZERO
	_weight_accumulator = 0.0


func _limit_speed():
	if horizontal_only:
		body.velocity.x = signf(body.velocity.x) * min(current_speed(), max_speed)
	else:
		body.velocity.limit_length(max_speed)
