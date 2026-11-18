extends HeroStateBase

func update(_delta: float) -> StringName:
	if not hero.is_on_floor():
		return "Fall"
	
	return &""
