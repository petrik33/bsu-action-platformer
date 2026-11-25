extends HeroStateBase

@export var animation: StringName = &"hide_gun"
@export var time: float = 0.5


func enter():
	gun.holster()
	hero.play_animation(animation, time)
	_schedule_transition(time, &"Idle")
