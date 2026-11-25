extends HeroStateBase


func enter():
	gun.aim()

func exit():
	gun.stop_aim()

func update(_delta: float) -> StringName:
	if not Input.is_action_pressed("aim"):
		return &"HolsterGun"
	if Input.is_action_just_pressed("click"):
		return &"Shoot"
	if Input.is_action_just_pressed("reload") and gun.can_reload():
		return &"StartReload"
	return &""
