extends HeroStateBase

@export var knockback_time := 0.3
@export var hurt_animation: StringName = &"hurt"


func enter():
	_state_timer(knockback_time, _on_finished)
	hero.play_animation(hurt_animation)
	kinematic.dash(hero.last_hurt.knockback)
	hero.face(signf(-hero.velocity.x))
	hero.set_resistance(true)

func exit():
	hero.set_resistance(false)

func _on_finished():
	_transition(&"Idle")
