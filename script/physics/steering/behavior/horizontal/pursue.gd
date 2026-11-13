class_name HorizontalPursue extends Pursue


func apply(kinematic: KinematicBase) -> Vector2:
	var position := Vector2(target_position.x, kinematic.global_position.y)
	var velocity := Vector2(target_velocity.x, 0.0)
	return target(position, velocity, kinematic)
