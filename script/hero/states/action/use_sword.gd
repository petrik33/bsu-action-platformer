extends HeroStateBase

@export var lock_speed_multiplier: float = 0.1


func update(_delta: float) -> StringName:
	hero.move_horizontally(lock_speed_multiplier)
	return &""
