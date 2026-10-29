extends EnemyStateBase

@export var knockback_resist := 500


func enter():
	steering.set_horizontal_velocity(0)
	enemy.play_animation(&"hurt")
	steering.set_instant_velocity(enemy.last_hurt.knockback)
	enemy.face(-enemy.velocity.x)

func update(delta: float) -> StringName:
	steering.set_horizontal_velocity(0)
	
	if not is_zero_approx(enemy.velocity.x):
		return &""
	elif perception.has_target():
		return &"Chase"
	else:
		return &"Investigate"
