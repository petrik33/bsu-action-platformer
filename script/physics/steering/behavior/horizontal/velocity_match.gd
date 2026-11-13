class_name HorizontalVelocityMatch extends SteeringBehaviorBase

@export var velocity: float


func apply(kinematic: KinematicBase) -> Vector2:
	return Vector2(velocity, kinematic.velocity.y)
