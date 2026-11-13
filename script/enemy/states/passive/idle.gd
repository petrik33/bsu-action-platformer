extends EnemyStateBase

@export var stop_behavior: SteeringBehaviorBase
@export var patrol_state: StringName = &"Patrol"
@export var idle_animation: StringName = &"idle"
@export var min_time: float = 0.8
@export var max_time: float = 1.8

var remaining_time: float = 0.0


func enter():
	steering.use(stop_behavior)
	enemy.play_animation(idle_animation)
	_state_timer(randf_range(min_time,max_time), _on_finished)

func _on_finished():
	enemy.face(-enemy.facing_direction())
	_transition(patrol_state)
