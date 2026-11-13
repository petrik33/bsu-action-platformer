class_name Seek extends SteeringBehaviorBase

@export var target_position: Vector2
@export var speed: float


func apply(kinematic: KinematicBase) -> Vector2:
	var to_target := target_position - kinematic.global_position
	return to_target.normalized() * speed
