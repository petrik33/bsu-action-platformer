extends HeroStateBase

@export var animation: StringName = &"aim"
@export var time: float = 0.1


func enter():
	hero.play_animation(animation, time)
	_schedule_transition(time, &"AimIdle")

func update(_delta: float) -> StringName:
	if not Input.is_action_pressed("shoot"):
		return &"Shoot"
	return &""
