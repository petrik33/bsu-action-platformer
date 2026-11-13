class_name KinematicGrounded extends KinematicBase

func current_speed() -> float:
	return absf(body.velocity.x)

func full_stop():
	body.velocity.x = 0.0


func _integrate(acceleration: Vector2, delta: float):
	body.velocity.x += acceleration.x * delta

func _limit_speed():
	body.velocity.x = signf(body.velocity.x) * minf(current_speed(), max_speed)
