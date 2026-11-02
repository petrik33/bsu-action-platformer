extends EnemyStateBase

@export var knockback_resist := 500
@export var knockback_vertically := true


func enter():
	steering.apply(0, 0)
	enemy.play_animation(&"hurt")
	if knockback_vertically:
		steering.dash_vec(enemy.last_hurt.knockback)
	else:
		steering.dash(enemy.last_hurt.knockback.x)
	enemy.face(-enemy.velocity.x)

func update(delta: float) -> StringName:
	steering.apply_forced(delta, 0, knockback_resist)

	if not is_zero_approx(enemy.velocity.x):
		return &""
	elif perception.has_target():
		return &"Chase"
	else:
		return &"Investigate"
