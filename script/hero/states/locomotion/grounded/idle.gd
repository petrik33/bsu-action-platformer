extends HeroStateBase


func enter():
	hero.play_animation("idle")

func update(delta: float) -> StringName:
	steering.apply(delta, 0)
	
	if not is_zero_approx(hero.movement_direction):
		return "Run"
	
	return &""
