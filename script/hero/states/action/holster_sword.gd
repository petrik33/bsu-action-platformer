extends HeroStateBase

@export var animation: StringName = &"holster_sword"
@export var time: float = 0.4


func enter():
	hero.play_animation(animation, time)
	_schedule_transition(time, &"Idle")
