extends HeroStateBase

@export var time: float = 1.0

func enter():
	hero.play_animation("death", time)
	_state_timer(time, _on_finished)


func _on_finished():
	_transition(&"Idle")
