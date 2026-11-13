class_name Steering extends PhysicsNodeBase

@export var kinematic: KinematicBase
@export var max_acceleration: float = 2000
@export var max_decceleration: float = 5000


var _behaviors: Array[SteeringBehaviorBase] = []
var _weights: Array[float] = []


func use(behavior: SteeringBehaviorBase) -> void:
	reset()
	add(behavior)

func add(behavior: SteeringBehaviorBase, weight: float = 1.0) -> void:
	if behavior == null or is_zero_approx(weight):
		return
	_behaviors.append(behavior)
	_weights.append(weight)

func reset() -> void:
	_behaviors.clear()
	_weights.clear()

func update(delta: float) -> void:
	if _behaviors.is_empty():
		return

	if kinematic == null:
		return

	var desired_velocity := Vector2.ZERO
	var total_weight := 0.0

	for i in _behaviors.size():
		desired_velocity += _behaviors[i].apply(kinematic) * _weights[i]
		total_weight += _weights[i]

	if total_weight > 0.0:
		kinematic.accelerate(_limit(desired_velocity / total_weight, delta), delta)


func _limit(desired_velocity: Vector2, delta: float) -> Vector2:
	var difference := desired_velocity - kinematic.velocity

	var limit := max_acceleration
	if difference.dot(kinematic.velocity) < 0.0:
		limit = max_decceleration

	var acceleration := (difference / delta).limit_length(limit)
	
	return acceleration

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if not owner is CharacterBody2D:
		warnings.append("Steering must be a child of a CharacterBody2D")
	if kinematic == null:
		warnings.append("Steering needs a KinematicBase to apply acceleration to")
	return warnings
