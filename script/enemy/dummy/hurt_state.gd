extends EnemyStateBase

@export var hurt_animation: StringName = &"hurt"
@export var time: float = 0.3

func enter():
	enemy.play_animation(hurt_animation, time, true)
	_schedule_transition(time, &"Idle")
