extends EnemyCharacterStateBase

@export var run_animation_name: StringName = &"run"
@export var arrival_distance := 16.0
@export var speed := 120.0


var to_target: float = 0.0


func enter() -> void:
	_update_target()
	enemy.face(to_target)
	
	if absf(to_target) <= arrival_distance:
		_transition(&"Attack")
		return
	
	enemy.play_animation(run_animation_name)
	enemy.move_horizontal(signf(to_target), speed)

func post_physics() -> StringName:
	_update_target()
	
	enemy.face_movement()
	
	if absf(to_target) <= arrival_distance:
		enemy.stop_horizontal()
		return &"Attack"
	
	if enemy.navigation.has_obstacles_ahead():
		return &"Investigate"
	
	return &""

func _update_target():
	to_target = enemy.perception.last_known_position.x - enemy.global_position.x
