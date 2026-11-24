extends HeroStateBase

@export var lock_speed_multiplier: float = 0.2


func enter():
	hero.aim_started.emit()

func exit():
	hero.aim_ended.emit()

func update(_delta: float) -> StringName:
	hero.move_horizontally(lock_speed_multiplier)
	return &""
