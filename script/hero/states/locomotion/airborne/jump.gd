extends HeroStateBase

@export var animation_name: StringName = &"jump"

func enter():
	hero.play_animation(animation_name)
	hero.jump()


func update(delta: float) -> StringName:
	if hero.velocity.y > 0:
		return "Fall"
	return &""
