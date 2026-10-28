extends EnemyStateBase

@export var knockback_resist := 500


func enter():
	enemy.stop_horizontal()
	enemy.play_animation(&"hurt")
	enemy.velocity = enemy.last_hurt.knockback
	enemy.face(-enemy.velocity.x)

func update(delta: float) -> StringName:
	enemy.velocity.x = move_toward(
		enemy.velocity.x,
		0.0,
		knockback_resist * delta
	)
	
	if not is_zero_approx(enemy.velocity.x):
		return &""
	elif perception.has_target():
		return &"Chase"
	else:
		return &"Investigate"
