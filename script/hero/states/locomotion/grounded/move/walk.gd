extends HeroStateBase

@export var walk_speed: float = 200
@export var animation_name: StringName = &"walk"


func enter():
	hero.play_animation(animation_name)

func exit():
	pass




func update(_delta: float) -> StringName:
	if steering:
		steering.set_horizontal_velocity(hero.movement_direction * walk_speed)

	if Input.is_action_just_pressed("walk"):
		return "Run"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return &""
