class_name AvoidObstacles extends SteeringBehaviorBase

@export var max_speed: float = 150.0
@export var distance: float = 16.0

var navigation: NavigationBase

func apply(kinematic: KinematicBase) -> Vector2:
	var ray := navigation.get_collision_ray()
	if ray == null or not ray.is_colliding():
		return Vector2.ZERO

	var target := ray.get_collision_point() + ray.get_collision_normal() * distance
	var to_target := target - kinematic.global_position
	if to_target.is_zero_approx():
		return Vector2.ZERO

	return to_target.normalized() * max_speed
