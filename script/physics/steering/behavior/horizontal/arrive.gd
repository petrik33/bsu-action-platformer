class_name HorizontalArrive extends Arrive


func apply(kinematic: KinematicBase) -> Vector2:
	return arrive_at(Vector2(target_position.x, kinematic.global_position.y), kinematic)
