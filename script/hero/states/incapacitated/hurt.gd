extends HeroStateBase

@export var knockback_time := 0.1

func enter():
	hero.play_animation(&"hurt")
	kinematic.dash(hero.last_hurt.knockback)
	hero.face(signf(-hero.velocity.x))

func update(delta: float) -> StringName:
	if is_zero_approx(hero.velocity.x):
		return &"Idle"

	kinematic.add_steering(steering.hstop(knockback_time))

	return &""
