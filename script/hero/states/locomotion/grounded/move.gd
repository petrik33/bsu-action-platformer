extends HeroStateBase


func update(_delta: float) -> StringName:
	if is_zero_approx(hero.movement_direction) and is_zero_approx(hero.velocity.x):
		return "Idle"
	
	return &""
