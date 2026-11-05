class_name EnemyChaseState extends EnemyStateBase

@export var run_animation_name: StringName = &"run"
@export var arrival_distance: float = 16.0
@export var slowing_distance: float = 40.0
@export var speed: float = 120.0
@export var attack_state: EnemyAttackState


func enter() -> void:
	if not enemy.can_chase():
		_transition(&"Investigate")
		return
	enemy.face_vector(perception.to_target())
	enemy.play_animation(run_animation_name)
	if attack_state.can_attack(perception.to_target()):
		_transition(&"Attack")
		return

func process(_delta: float) -> void:
	enemy.face_movement()

func update(delta: float) -> StringName:
	if not enemy.can_chase():
		return &"Investigate"
	
	if attack_state.can_attack(perception.to_target()):
		return &"Attack"
	
	kinematic.add_steering(steering.pursue(
		perception.last_known_position(),
		perception.target().velocity,
		kinematic.max_speed,
		arrival_distance,
		slowing_distance
	))
	
	return &""
