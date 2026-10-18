extends EnemyCharacterStateBase

@export var run_animation_name: StringName = &"run"
@export var arrival_distance := 12.0
@export var speed := 120.0


var to_target: float = 0.0


func enter() -> void:
	enemy.play_animation(run_animation_name)
	_update_target()

func update_physics(_delta: float) -> void:
	enemy.move_horizontal(signf(to_target), speed)

func post_physics() -> StringName:
	_update_target()
	
	if absf(to_target) <= arrival_distance:
		enemy.stop_horizontal()
		return &"Attack"
	
	if enemy.has_obstacle_ahead():
		return &"Investigate"
	
	return &""

func _update_target():
	to_target = enemy.perception.last_known_position.x - enemy.global_position.x
