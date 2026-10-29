class_name GhostChaseState extends EnemyStateBase

@export var speed: float = 150.0
@export var avoidance_weight: float = 2.0
@export var arrival_distance: float = 32.0
@export var attack_state: EnemyAttackState

func enter() -> void:
	if perception.has_target():
		enemy.face_vector(perception.to_target())

func process(_delta: float) -> void:
	enemy.face_movement()

func update(delta: float) -> StringName:
	if not perception.has_target():
		return &"Investigate"
	
	var target_pos = perception.target.global_position
	var current_pos = enemy.global_position
	var to_target = target_pos - current_pos
	var direction = to_target.normalized()
	
	var desired_velocity = Vector2(direction * speed)
	
	if navigation is EnemyNavigationFlying:
		var avoid_vec = navigation.get_avoidance_vector()
		if avoid_vec != Vector2.ZERO:
			desired_velocity += avoid_vec * speed * avoidance_weight
	
	steering.apply_vec(delta, desired_velocity)
	
	if to_target.length() < arrival_distance:
		if _can_attack():
			return &"Attack"
		else:
			steering.stop_vec(delta)
	
	return &""

func _can_attack() -> bool:
	if attack_state and attack_state.is_ready():
		return true
	return false
