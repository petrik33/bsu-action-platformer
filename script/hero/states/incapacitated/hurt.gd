extends HeroStateBase

@export var knockback_resist := 500


func enter():
	hero.play_animation(&"hurt")
	steering.dash_vec(hero.last_hurt.knockback)
	hero.face(signf(-hero.velocity.x))

	func update(delta: float) -> StringName:
	steering.set_acceleration_override(knockback_resist)

	if is_zero_approx(hero.velocity.x):
		return &"Idle"

	return &""
