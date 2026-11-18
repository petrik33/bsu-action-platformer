extends HeroStateBase

@export var death_animation: StringName = &"death"
@export var time: float = 0.4

func enter():
	kinematic.full_stop()
	hero.play_animation(death_animation, time)
	_schedule_transition(time, &"Idle")
