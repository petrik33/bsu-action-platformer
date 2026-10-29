extends HeroStateBase

@export var animation_name: StringName = &"jump"

func enter():
	hero.play_animation(animation_name)
	hero.jump()


func update(_delta: float) -> StringName:
	steering.set_horizontal_velocity(0)
	if hero.velocity.y > 0:
		return "Fall"
	return &""
