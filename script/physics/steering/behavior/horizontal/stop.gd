class_name HorizontalStop extends SteeringBehaviorBase


func apply(kinematic: KinematicBase) -> Vector2:
	return Vector2(0.0, kinematic.velocity.y)
