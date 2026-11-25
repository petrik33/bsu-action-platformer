extends HeroStateBase

@export var animation: StringName = &"aim"
@export var time: float = 0.1


func enter():
	hero.play_animation(animation, time)
	_schedule_transition(time, &"AimIdle")
