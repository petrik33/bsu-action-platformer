extends HeroStateBase

@export var animation_name: StringName = &"run"


func enter():
	hero.play_animation(animation_name)

func update(_delta: float) -> StringName:
	steering.set_horizontal_velocity(hero.movement_direction * hero.base_speed)

	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return &""
