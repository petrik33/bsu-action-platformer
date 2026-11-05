extends HeroStateBase


@export_group("Animation Thresholds")
@export var sprint_threshold: float = 500.0
@export var run_threshold: float = 250.0
@export var walk_threshold: float = 10.0

@export_group("Animation Names")
@export var sprint_animation: StringName = &"sprint"
@export var run_animation: StringName = &"run"
@export var walk_animation: StringName = &"walk"
@export var idle_animation: StringName = &"idle"

@export_group("Speed Multipliers")
@export var walk_multiplier: float = 0.5
@export var run_multiplier: float = 1.0
@export var sprint_multiplier: float = 1.5

var _current_multiplier := 1.0


func process(delta: float) -> void:
	var speed := absf(hero.velocity.x)
	
	if speed > sprint_threshold:
		hero.play_animation(sprint_animation)
	elif speed > run_threshold:
		hero.play_animation(run_animation)
	elif speed > walk_threshold:
		hero.play_animation(walk_animation)
	else:
		hero.play_animation(idle_animation)


func update(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		_current_multiplier = walk_multiplier if not is_equal_approx(_current_multiplier, walk_multiplier) else run_multiplier
	elif Input.is_action_just_pressed("sprint"):
		_current_multiplier = sprint_multiplier if not is_equal_approx(_current_multiplier, sprint_multiplier) else run_multiplier
	
	hero.move_horizontally(_current_multiplier)
	
	if is_zero_approx(hero.movement_direction) and is_zero_approx(hero.velocity.x):
		return &"Idle"
	
	return &""
