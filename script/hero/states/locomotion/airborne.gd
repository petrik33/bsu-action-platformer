extends HeroStateBase


func update(_delta: float) -> StringName:
	hero.move_horizontally()
		
	if hero.is_on_floor():
		return "Idle"
	
	return &""
