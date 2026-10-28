class_name EnemyAttackState extends EnemyStateBase

@export var cooldown: float = 1.2
@export var time: float = 0.5

var _next_attack_time_msec: int = 0


func enter() -> void:
	enemy.stop_horizontal()
	enemy.face_vector(perception.to_target())
	enemy.play_animation(&"attack", time)
	_state_timer(time, _on_finished)

func is_ready() -> bool:
	return Time.get_ticks_msec() >= _next_attack_time_msec


func _on_finished() -> void:
	_next_attack_time_msec = Time.get_ticks_msec() + int(cooldown * 1000.0)
	_transition(&"Chase")
