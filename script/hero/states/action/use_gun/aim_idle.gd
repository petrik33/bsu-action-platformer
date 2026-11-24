extends HeroStateBase

@export var animation: StringName = &"aim_idle"


func enter():
	hero.play_animation(animation)

func update(_delta: float) -> StringName:
	if not Input.is_action_pressed("shoot"):
		return &"Shoot"
	return &""
