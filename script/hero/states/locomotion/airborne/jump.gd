extends HeroStateBase

@export var animation_name: StringName = &"jump"


func enter():
	hero.jump()
	hero.play_animation(animation_name)

func update(_delta: float) -> StringName:
	if hero.velocity.y > 0:
		return "Fall"
	return &""
