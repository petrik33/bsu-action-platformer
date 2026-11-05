class_name KinematicFlying extends KinematicBase

var _accumulated_steering: Vector2 = Vector2.ZERO

func current_speed() -> float:
	return body.velocity.length()

func full_stop():
	body.velocity = Vector2.ZERO

func dash(velocity: Vector2):
	body.velocity = velocity


func _accumulate_steering(steering: Vector2, weight: float = 1.0):
	_accumulated_steering += steering * weight

func _consume_accumulated_steering(delta: float, max_acceleration: float):
	var blended_steering := _accumulated_steering / _weight_accumulator
	blended_steering = blended_steering.limit_length(max_acceleration)
	body.velocity += blended_steering * delta
	_accumulated_steering = Vector2.ZERO

func _limit_speed():
	body.velocity = body.velocity.limit_length(max_speed)
