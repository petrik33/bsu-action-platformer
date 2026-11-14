extends EnemyStateBase

@export var walk_animation: StringName = &"walk"
@export var arrive_behavior: Arrive
@export var avoid_behavior: AvoidObstacles
@export var avoidance_weight := 2.0

var direction := 1.0


func enter() -> void:
	direction = enemy.facing_direction()
	enemy.play_animation(walk_animation)
	arrive_behavior.target_position = patroling.get_patrol_point(rng, direction)
	steering.use(arrive_behavior)
	if avoid_behavior != null:
		avoid_behavior.navigation = navigation
		steering.add(avoid_behavior, avoidance_weight)

func process(delta: float) -> void:
	enemy.face_movement()

func update(_delta: float) -> StringName:
	if arrive_behavior.has_arrived_at_target(kinematic):
		return &"Idle"
	return &""
