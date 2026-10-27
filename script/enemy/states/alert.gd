extends EnemyCharacterStateBase

@export var alert_time: float = 0.6


func enter() -> void:
	enemy.stop_horizontal()
	enemy.face_vector(perception.to_target())
	enemy.play_alert_vfx(alert_time)
	_state_timer(alert_time, _on_finished)


func _on_finished() -> void:
	if perception.has_target():
		_transition(&"Chase")
	else:
		_transition(&"Investigate")
