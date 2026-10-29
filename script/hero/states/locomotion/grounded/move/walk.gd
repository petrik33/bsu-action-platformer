extends HeroStateBase

@export var speed_multiplier: float = 0.5
@export var animation_name: StringName = &"walk"


func enter():
	hero.play_animation(animation_name)

func update(delta: float) -> StringName:
	steering.apply(delta, hero.movement_direction * hero.base_speed * speed_multiplier)

	if Input.is_action_just_pressed("walk"):
		return "Run"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return &""
