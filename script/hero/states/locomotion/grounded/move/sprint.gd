extends HeroStateBase

@export var sprint_speed: float = 600
@export var animation_name: StringName = &"sprint"


func enter():
	hero.play_animation(animation_name)

func exit():
	pass




func update(_delta: float) -> StringName:
	if steering:
		steering.set_horizontal_velocity(hero.movement_direction * sprint_speed)

	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return &""
