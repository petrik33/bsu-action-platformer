extends EnemyStateBase

@export var stop_behavior: SteeringBehaviorBase
@export var search_animation_name: StringName = &"walk"
@export var wait_animation_name: StringName = &"idle"
@export var arrive_behavior: Arrive
@export var wait_time: float = 1.0
@export var avoid_behavior: AvoidObstacles
@export var avoidance_weight := 2.0

var _waiting := false


func enter() -> void:
	_waiting = false
	
	if not navigation.can_reach(perception.last_known_position()):
		_begin_wait()
		return
	
	arrive_behavior.target_position = perception.last_known_position()
	steering.use(arrive_behavior)
	if avoid_behavior != null:
		avoid_behavior.navigation = navigation
		steering.add(avoid_behavior, avoidance_weight)
	
	enemy.play_animation(search_animation_name)

func process(_delta: float) -> void:
	enemy.face_movement()

func update(_delta: float) -> StringName:
	if perception.has_target() and navigation.can_reach(perception.last_known_position()):
		return &"Chase"
	
	if _waiting:
		return &""
	
	if arrive_behavior.has_arrived_at_target(kinematic):
		_begin_wait()
		return &""
	
	return &""

func _begin_wait() -> void:
	_waiting = true
	steering.use(stop_behavior)
	enemy.play_animation(wait_animation_name)
	_state_timer(wait_time, _on_wait_finished)

func _on_wait_finished() -> void:
	_transition(&"Idle")
