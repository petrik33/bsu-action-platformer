extends HeroStateBase

@export var speed_multiplier: float = 1.5
@export var animation_name: StringName = &"sprint"


func enter():
	hero.play_animation(animation_name)

func update(_delta: float) -> StringName:
	steering.set_horizontal_velocity(hero.movement_direction * hero.base_speed * speed_multiplier)

	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return &""
