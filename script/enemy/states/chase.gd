class_name EnemyChaseState extends EnemyCharacterStateBase

@export var run_animation_name: StringName = &"run"
@export var arrival_distance: float = 16.0
@export var speed: float = 120.0
@export var attack_state: EnemyAttackState


func enter() -> void:
	enemy.face_vector(perception.to_target())
	enemy.play_animation(run_animation_name)
	if _can_attack():
		_transition(&"Attack")
		return

func process(_delta: float) -> void:
	enemy.face_movement()


func update(_delta: float) -> StringName:
	if absf(perception.to_target().x) > arrival_distance:
		enemy.move_horizontal(signf(perception.to_target().x), speed)
	else:
		enemy.stop_horizontal()

	if not perception.has_target() or enemy.navigation.has_obstacles_ahead():
		return &"Investigate"

	if _can_attack():
		return &"Attack"

	return &""


func _can_attack() -> bool:
	if absf(perception.to_target().x) > arrival_distance:
		return false
	if not attack_state.is_ready():
		return false
	return true
