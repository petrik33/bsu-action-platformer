extends EnemyStateBase

@export var death_animation: StringName = &"death"
@export var time: float = 1.0
@export var remove_on_finish: bool = true


func enter():
	steering.reset()
	kinematic.full_stop()
	enemy.play_animation(death_animation)
	_state_timer(time, _on_finished)


func _on_finished():
	if remove_on_finish:
		enemy.queue_free()
