extends HeroStateBase

@export var speed_multiplier: float = 1.5
@export var animation_name: StringName = &"sprint"


func enter():
	hero.play_animation(animation_name)

func update(delta: float) -> StringName:
	hero.move_horizontally(delta, speed_multiplier)

	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return &""
