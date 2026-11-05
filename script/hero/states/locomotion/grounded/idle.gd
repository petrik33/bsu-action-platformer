extends HeroStateBase

@export var idle_animation: StringName = &"idle"

func enter():
	hero.play_animation(idle_animation)

func update(_delta: float) -> StringName:
	if not is_zero_approx(hero.movement_direction):
		return &"Move"
	
	kinematic.add_steering(steering.hstop())
	
	return &""
