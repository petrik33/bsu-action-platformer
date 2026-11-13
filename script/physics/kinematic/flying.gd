class_name KinematicFlying extends KinematicBase

func current_speed() -> float:
	return body.velocity.length()

func full_stop():
	body.velocity = Vector2.ZERO


func _integrate(acceleration: Vector2, delta: float):
	body.velocity += acceleration * delta

func _limit_speed():
	body.velocity = body.velocity.limit_length(max_speed)
