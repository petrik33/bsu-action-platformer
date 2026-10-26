extends EnemyCharacterStateBase


@export var alert_time: float = 0.6
@export var timer: Timer

func enter() -> void:
	enemy.stop_horizontal()
	_face_threat()
	enemy.play_alert_vfx(alert_time)
	timer.start(alert_time)

func exit() -> void:
	timer.stop()

func _face_threat() -> void:
	if enemy.perception != null:
		var to_target: float = enemy.perception.last_known_position.x - enemy.global_position.x
		enemy.face(to_target)

func _on_timer_timeout() -> void:
	if enemy.perception.has_target():
		_transition(&"Chase")
	else:
		_transition(&"Patrol")
