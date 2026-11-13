extends HeroStateBase

@export var idle_animation: StringName = &"idle"
@export var stop_behavior: SteeringBehaviorBase

func enter():
	steering.use(stop_behavior)
	hero.play_animation(idle_animation)

func update(_delta: float) -> StringName:
	if not is_zero_approx(hero.movement_direction):
		return &"Move"
	
	return &""
