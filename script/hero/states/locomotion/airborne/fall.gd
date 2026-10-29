extends HeroStateBase

@export var animation_name: StringName = &"fall"

func enter():
	hero.play_animation(animation_name)
