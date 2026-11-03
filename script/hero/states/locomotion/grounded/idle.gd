extends HeroStateBase


func enter():
	hero.play_animation("idle")

func update(delta: float) -> StringName:
	if not is_zero_approx(hero.movement_direction):
		return "Run"
	
	return &""
