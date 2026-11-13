class_name Pursue extends Arrive

@export var target_velocity: Vector2
@export var max_prediction: float = 0.05


func apply(kinematic: KinematicBase) -> Vector2:
	return target(target_position, target_velocity, kinematic)

func target(position: Vector2, velocity: Vector2, kinematic: KinematicBase) -> Vector2:
	var distance := (position - kinematic.global_position).length()
	var speed := kinematic.current_speed()
	var prediction := minf(distance / maxf(speed, 0.1), max_prediction)
	return arrive_at(position + velocity * prediction, kinematic)
