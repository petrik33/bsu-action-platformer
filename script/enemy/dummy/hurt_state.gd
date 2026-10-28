extends EnemyCharacterStateBase

@export var time: float = 0.3

func enter():
	enemy.play_animation(&"hurt", time)
	_state_timer(time, _on_finished)


func _on_finished():
	_transition(&"Idle")
