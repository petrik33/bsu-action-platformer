extends HeroStateBase

@export var lock_speed_multiplier: float = 0.2


func enter():
	if gun == null:
		_transition(&"Idle")
		return
	gun.draw()
	if gun.is_clip_empty():
		_transition(&"StartReload")
		return
	_transition(&"StartAim")

func exit():
	if not gun.is_holstered:
		gun.holster()

func update(_delta: float) -> StringName:
	hero.move_horizontally(lock_speed_multiplier)
	return &""
