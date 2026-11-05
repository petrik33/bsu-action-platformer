extends HeroStateBase

@export var death_animation: StringName = &"death"
@export var time: float = 0.4

func enter():
	hero.play_animation(death_animation, time)
	_state_timer(time, _on_finished)


func _on_finished():
	_transition(&"Idle")
