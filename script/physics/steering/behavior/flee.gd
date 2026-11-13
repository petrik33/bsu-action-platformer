class_name Flee extends Seek

func apply(kinematic: KinematicBase) -> Vector2:
	return -super.apply(kinematic)
