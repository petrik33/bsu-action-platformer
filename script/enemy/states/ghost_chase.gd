class_name GhostChaseState extends EnemyStateBase

@export var speed: float = 150.0
@export var avoidance_weight: float = 2.0
@export var arrival_distance: float = 32.0
@export var attack_state: EnemyAttackState

func enter() -> void:
	# Ensure the ghost is facing the target initially
	if perception.has_target():
		enemy.face_vector(perception.to_target())
	
	# Use generic ghost chase animation if available, otherwise "idle"
	enemy.play_animation(&"chase")

func update(delta: float) -> StringName:
	if not perception.has_target():
		return &"Passive"
	
	var target_pos = perception.target.global_position
	var current_pos = enemy.global_position
	var to_target = target_pos - current_pos
	var direction = to_target.normalized()
	
	# 1. Seek: Basic move towards target (Horizontal only)
	# We isolate X to let the FloatingComponent handle the Y-axis (bobbing/ground-follow)
	var desired_velocity = Vector2(direction.x * speed, 0)
	
	# 2. Avoidance: Modify velocity based on obstacles
	if navigation is EnemyNavigationFlying:
		var avoid_vec = navigation.get_avoidance_vector()
		if avoid_vec != Vector2.ZERO:
			# Blend avoid_vec into desired_velocity
			desired_velocity += avoid_vec * speed * avoidance_weight
	
	# Update facing direction based on movement
	if enemy.velocity.length() > 10:
		enemy.face_vector(enemy.velocity.normalized())
	
	# Apply the calculated velocity through the steering component
	steering.apply_forced_vec(delta, desired_velocity, steering.acceleration)
	
	# Transition to Attack state if close enough
	if to_target.length() < arrival_distance:
		if _can_attack():
			return &"Attack"
		else:
			# Decelerate when arriving at target but not yet attacking
			steering.apply_forced_vec(delta, Vector2.ZERO, steering.deceleration)
	
	return &""

func _can_attack() -> bool:
	if attack_state and attack_state.is_ready():
		return true
	return false
