extends HeroStateBase

@export var animation: StringName = &"aim_idle"


func enter():
	hero.play_animation(animation)
