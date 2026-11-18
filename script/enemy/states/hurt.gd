extends EnemyStateBase

@export var hurt_animation: StringName = &"hurt"
@export var knockback_time := 0.2
@export var knockback_vertically := true


func enter():
	steering.reset()
	if knockback_vertically:
		kinematic.dash(enemy.last_hurt.knockback)
	else:
		kinematic.dash(Vector2(enemy.last_hurt.knockback.x, 0))
	enemy.set_resistance(true)
	enemy.face(-enemy.velocity.x)
	enemy.play_animation(hurt_animation)
	_state_timer(knockback_time, _on_finished)

func exit():
	enemy.set_resistance(false)

func _on_finished():
	if enemy.passive:
		_transition(&"Idle")
		return
	
	if perception.has_target():
		_transition(&"Chase")
	else:
		_transition(&"Investigate")
