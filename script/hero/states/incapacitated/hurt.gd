extends HeroStateBase

@export var knockback_resist := 500


func enter():
	hero.play_animation(&"hurt")
	if steering:
		steering.set_instant_velocity(hero.last_hurt.knockback)
	else:
		hero.velocity = hero.last_hurt.knockback
	hero.face(signf(-hero.velocity.x))

func exit():
	hero.unlock_movement()

func update(delta: float) -> StringName:
	if steering:
		# Use steering to slow down to 0
		steering.set_horizontal_velocity(0)
	else:
		hero.velocity.x = move_toward(
			hero.velocity.x,
			0.0,
			knockback_resist * delta
		)
	
	if is_zero_approx(hero.velocity.x):
		return &"Idle"
	
	return &""
