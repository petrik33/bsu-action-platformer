extends EnemyStateBase

@export var alert_time: float = 0.6


func enter() -> void:
	enemy.face_vector(perception.to_target())
	enemy.play_alert_vfx(alert_time)
	_state_timer(alert_time, _on_finished)

func update(delta: float) -> StringName:
	steering.apply(delta, 0)
	return &""


func _on_finished() -> void:
	if perception.has_target():
		_transition(&"Chase")
	else:
		_transition(&"Investigate")
