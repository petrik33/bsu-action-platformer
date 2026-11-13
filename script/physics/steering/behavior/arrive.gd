class_name Arrive extends SteeringBehaviorBase

@export var target_position: Vector2
@export var max_speed: float = 150.0
@export var arrival_radius: float = 8.0
@export var slowing_radius: float = 64.0


func apply(kinematic: KinematicBase) -> Vector2:
	return arrive_at(target_position, kinematic)

func arrive_at(position: Vector2, kinematic: KinematicBase) -> Vector2:
	var to_target := position - kinematic.global_position
	var distance := to_target.length()

	if distance <= arrival_radius:
		return Vector2.ZERO

	var speed_factor := clampf(distance / slowing_radius, 0.0, 1.0)
	return to_target.normalized() * max_speed * speed_factor

func has_arrived_at_target(kinematic: KinematicBase) -> bool:
	var to_target := target_position - kinematic.global_position
	var distance := to_target.length()
	return distance <= arrival_radius
