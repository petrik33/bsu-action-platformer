extends HeroStateBase


func update(_delta: float) -> StringName:
	if is_zero_approx(hero.movement_direction):
		return "Idle"
	
	return &""
