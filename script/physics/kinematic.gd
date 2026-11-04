class_name Kinematic extends PhysicsNodeBase

@export var max_speed: float = 500.0

var _steering_accumulator := Vector2.ZERO
var _weight_accumulator := 0.0

func dash(velocity: Vector2):
	body.velocity = velocity

func add_steering(steering: Vector2, weight: float = 1.0):
	if steering.is_zero_approx():
		return
	_steering_accumulator += steering * weight
	_weight_accumulator += weight

func apply_steering(delta: float, max_acceleration: float):
	if _weight_accumulator <= 0:
		return
	
	var blended_steering = _steering_accumulator / _weight_accumulator
	blended_steering = blended_steering.limit_length(max_acceleration)
	
	body.velocity += blended_steering * delta
	body.velocity.limit_length(max_speed)
	
	_steering_accumulator = Vector2.ZERO
	_weight_accumulator = 0.0
