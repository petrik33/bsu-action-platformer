extends HeroStateBase


func exit():
	if gun.is_reloading:
		gun.cancel_reload()
