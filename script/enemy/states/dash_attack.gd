extends EnemyStateBase


@export var cooldown: float = 1.2
@export var time: float = 0.5

var _last_attack_time_msec: int = 0


func enter() -> void:
	_last_attack_time_msec = Time.get_ticks_msec()
	steering.dash(0)
	enemy.face_vector(perception.to_target())
	enemy.play_animation(&"attack", time)
	_state_timer(time, _on_finished)

func is_ready() -> bool:
	return Time.get_ticks_msec() >= _last_attack_time_msec + int(cooldown * 1000.0)


func _on_finished() -> void:
	_transition(&"Chase")
