class_name KinematicGrounded extends KinematicBase

var _accumulated_steering: float = 0.0

func current_speed() -> float:
	return absf(body.velocity.x)

func full_stop():
	body.velocity.x = 0.0

func dash(velocity: Vector2):
	body.velocity.x = velocity.x


func _accumulate_steering(steering: Vector2, weight: float = 1.0):
	_accumulated_steering += steering.x * weight

func _consume_accumulated_steering(delta: float, max_acceleration: float):
	var blended_steering := _accumulated_steering / _weight_accumulator
	blended_steering = clampf(blended_steering, -max_acceleration, max_acceleration)
	body.velocity.x += blended_steering * delta
	_accumulated_steering = 0.0

func _limit_speed():
	body.velocity.x = signf(body.velocity.x) * min(current_speed(), max_speed)
