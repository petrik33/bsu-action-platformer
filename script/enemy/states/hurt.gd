extends EnemyStateBase

@export var knockback_time := 0.2
@export var knockback_vertically := true

func enter():
	_state_timer(knockback_time, _on_finished)
	enemy.play_animation(&"hurt")
	if knockback_vertically:
		kinematic.dash(enemy.last_hurt.knockback)
	else:
		kinematic.dash(Vector2(enemy.last_hurt.knockback.x, 0.0))
	enemy.face(-enemy.velocity.x)

func update(delta: float) -> StringName:
	kinematic.add_steering(steering.hstop(knockback_time))
	return &""


func _on_finished():
	if perception.has_target():
		_transition(&"Chase")
	else:
		_transition(&"Investigate")
