extends HeroStateBase

@export var knockback_time := 0.3

@export var hurt_animation: StringName = &"hurt"

func enter():
	_state_timer(knockback_time, _on_finished)
	hero.play_animation(hurt_animation)
	kinematic.dash(hero.last_hurt.knockback)
	hero.face(signf(-hero.velocity.x))

func update(delta: float) -> StringName:
	kinematic.add_steering(steering.hstop(knockback_time))
	return &""


func _on_finished():
	_transition(&"Idle")
