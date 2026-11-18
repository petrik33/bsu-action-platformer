extends HeroStateBase

@export var knockback_time := 0.3
@export var hurt_animation: StringName = &"hurt"


func enter():
	_schedule_transition(knockback_time, &"Idle")
	hero.play_animation(hurt_animation)
	kinematic.dash(hero.last_hurt.knockback)
	hero.face(signf(-hero.velocity.x))
	hero.set_resistance(true)

func exit():
	hero.set_resistance(false)
