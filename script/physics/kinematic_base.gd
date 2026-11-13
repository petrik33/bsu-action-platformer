@abstract
class_name KinematicBase extends PhysicsNodeBase

@export var max_speed: float = 150.0

var velocity: Vector2:
	get():
		return body.velocity

var global_position: Vector2:
	get():
		return body.global_position

@abstract func current_speed() -> float
@abstract func full_stop()

func dash(desired_velocity: Vector2):
	body.velocity = desired_velocity

func accelerate(acceleration: Vector2, delta: float):
	_integrate(acceleration, delta)
	_limit_speed()


@abstract func _integrate(acceleration: Vector2, delta: float)
@abstract func _limit_speed()
