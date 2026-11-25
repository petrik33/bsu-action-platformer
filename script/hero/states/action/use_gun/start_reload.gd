extends HeroStateBase

@export var animation: StringName = &"prepare_reload"
@export var time: float = 0.35


func enter():
	gun.reload()
	hero.play_animation(animation, time)
	_schedule_transition(time, &"ProgressReload")
