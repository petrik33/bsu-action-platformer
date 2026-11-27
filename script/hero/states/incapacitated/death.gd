extends HeroStateBase

@export var death_animation: StringName = &"death"


func enter():
	steering.reset()
	kinematic.full_stop()
	if death_animation != &"":
		hero.play_animation(death_animation)
