class_name EnemyChaseState extends EnemyStateBase

@export var run_animation_name: StringName = &"run"
@export var pursue_behavior: Pursue
@export var avoid_behavior: AvoidObstacles
@export var avoidance_weight: float = 2.0
@export var jump_off_ledges: bool = false


func enter() -> void:
	steering.use(pursue_behavior)
	if avoid_behavior != null:
		avoid_behavior.navigation = navigation
		steering.add(avoid_behavior, avoidance_weight)
	enemy.face_vector(perception.to_target())
	enemy.play_animation(run_animation_name)

func process(_delta: float) -> void:
	enemy.face_movement()

func update(_delta: float) -> StringName:
	if not perception.has_target():
		return &"Investigate"
	
	if enemy.can_attack(perception.to_target()):
		return &"Attack"
	
	pursue_behavior.target_position = perception.last_known_position()
	pursue_behavior.target_velocity = perception.target().velocity
	
	if not _can_advance():
		return &"Investigate"
	
	return &""

func _can_advance() -> bool:
	if avoid_behavior != null:
		return true
	
	enemy.navigation.force_update()
	
	if enemy.navigation.has_wall_ahead():
		return false
	
	if not enemy.navigation.has_ledge_ahead():
		return true
	
	if not jump_off_ledges:
		return false
	
	return true
