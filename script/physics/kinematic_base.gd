@abstract
class_name KinematicBase extends PhysicsNodeBase

@export var max_speed: float = 150.0
@export var stop_buffer: float = 0.5

var _weight_accumulator := 0.0


@abstract func current_speed() -> float
@abstract func full_stop()
@abstract func dash(velocity: Vector2)


func add_steering(steering: Vector2, weight: float = 1.0):
	if steering.is_zero_approx():
		return
	_accumulate_steering(steering, weight)
	_weight_accumulator += weight

func apply_steering(delta: float, max_acceleration: float):
	if _weight_accumulator <= 0:
		return

	_consume_accumulated_steering(delta, max_acceleration)
	
	if current_speed() <= stop_buffer:
		full_stop()
	else:
		_limit_speed()

	_weight_accumulator = 0.0


@abstract func _accumulate_steering(steering: Vector2, weight: float = 1.0)
@abstract func _consume_accumulated_steering(delta: float, max_acceleration: float)
@abstract func _limit_speed()
