extends EnemyStateBase


@export var min_time: float = 0.8
@export var max_time: float = 1.8

var remaining_time: float = 0.0


func enter():
	steering.dash(0)
	enemy.play_animation(&"idle")
	remaining_time = randf_range(min_time,max_time)




func update(delta: float) -> StringName:
	remaining_time -= delta
	if remaining_time <= 0:
		enemy.face(-enemy.facing_direction())
		return &"Patrol"
	
	return &""
	
